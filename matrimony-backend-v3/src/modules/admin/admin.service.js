// src/services/adminService.js
import mongoose from "mongoose";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import fs from "fs/promises"; // For reading files from disk
import path from "path"; // For handling file paths
import cloudinary from "cloudinary"; // For image uploads
import dotenv from "dotenv";
import Admin from "./admin.schema.js";
import Matrimony from "../brideGroom/bridegroom.schema.js";
import { sendEmail } from "../../utils/sendEmail.js";
import { validatePassword } from "../../utils/validatePassword.js";

dotenv.config();

// In-memory OTP store (email -> otp info)
const otpStore = new Map();

// Clean up expired OTPs every minute
setInterval(() => {
  const now = Date.now();
  let cleanedCount = 0;

  for (const [email, record] of otpStore.entries()) {
    if (now > record.expiresAt) {
      otpStore.delete(email);
      cleanedCount++;
    }
  }

  if (cleanedCount > 0) {
    console.log(
      `🧹 Cleaned up ${cleanedCount} expired OTPs at ${new Date().toISOString()}`
    );
  }
}, 60 * 1000);

export const cookieOption = {
  maxAge: 7 * 24 * 60 * 60 * 1000,
  httpOnly: true,
  secure: process.env.NODE_ENV === "production",
  sameSite: "Lax",
};

// Generic service-layer error carrying an HTTP status code and optional extra payload
export class AppError extends Error {
  constructor(status, message, extra = {}) {
    super(message);
    this.name = "AppError";
    this.status = status;
    this.extra = extra;
  }
}

// Helper function to parse stringified JSON
export const parseIfString = (data) => {
  if (typeof data === "string") {
    try {
      return JSON.parse(data);
    } catch {
      return {};
    }
  }
  return data || {};
};

// Helper function to flatten validation errors
export const flattenValidationErrors = (error) => {
  const errors = {};
  for (const field in error.errors) {
    errors[field] = error.errors[field].message;
  }
  return errors;
};

// Helper function to clean numeric fields
export const cleanNumericFields = (data) => {
  if (!data || typeof data !== "object") return data;

  const cleaned = { ...data };

  const numericFields = [
    "annualIncome",
    "height",
    "weight",
    "expectedSalary",
    "age",
    "mobileNumber",
    "phoneNumber",
    "pinCode",
    "income",
    "salary",
    "familyIncome",
    "partnerIncome",
    "expectedIncome",
    "fatherIncome",
    "motherIncome",
    "siblingIncome",
    "financialValue",
    "assetsValue",
  ];

  numericFields.forEach((field) => {
    if (cleaned[field] !== undefined && cleaned[field] !== null) {
      if (typeof cleaned[field] === "string") {
        const numericValue = cleaned[field].replace(/[^\d.-]/g, "").trim();
        if (numericValue && !isNaN(parseFloat(numericValue))) {
          cleaned[field] = parseFloat(numericValue);
        } else {
          delete cleaned[field];
        }
      }
    }
  });

  return cleaned;
};

export const isEmailAllowed = (email) => {
  const allowedEmails =
    process.env.ALLOWED_ADMIN_EMAILS?.split(",").map((e) =>
      e.trim().toLowerCase()
    ) || [];
  return allowedEmails.includes(email.toLowerCase());
};

// Helper: safely turn a mongoose subdoc/object into a plain object
const getSafeObject = (obj) => {
  if (!obj || typeof obj !== "object") return {};
  try {
    return obj.toObject ? obj.toObject() : { ...obj };
  } catch {
    return { ...obj };
  }
};

// Helper: merge an existing section with cleaned new data
const mergeObjectsSafely = (existingObj, newObj) => {
  const safeExisting = getSafeObject(existingObj);
  const safeNew = cleanNumericFields(newObj);
  return { ...safeExisting, ...safeNew };
};

const signAdminToken = (admin) =>
  jwt.sign(
    { adminId: admin._id, email: admin.email, role: admin.role },
    process.env.JWT_SECRET,
    { expiresIn: "24h" }
  );

/* ------------------------------------------------------------------
   AUTH
-------------------------------------------------------------------*/

export const signupAdmin = async ({
  name,
  email,
  mobileNumber,
  password,
  confirmPassword,
}) => {
  if (!name || !email || !mobileNumber || !password || !confirmPassword) {
    throw new AppError(400, "All fields are required");
  }

  if (!isEmailAllowed(email)) {
    throw new AppError(403, "This email is not authorized for admin registration");
  }

  if (password !== confirmPassword) {
    throw new AppError(400, "Passwords do not match");
  }

  const errors = validatePassword(password);
  if (errors.length > 0) {
    throw new AppError(400, errors.join(", "));
  }

  const existingAdmin = await Admin.findOne({ email });
  if (existingAdmin) {
    throw new AppError(400, "Admin already registered with this email");
  }

  const newAdmin = await Admin.create({ name, email, mobileNumber, password });

  if (!newAdmin) {
    throw new AppError(500, "Failed to create admin");
  }

  const token = signAdminToken(newAdmin);

  return {
    token,
    admin: { ...newAdmin.toObject(), password: undefined },
  };
};

export const loginAdmin = async (email, password) => {
  if (!email || !password) {
    throw new AppError(400, "All fields are required");
  }

  if (!isEmailAllowed(email)) {
    throw new AppError(403, "This email is not authorized for admin access");
  }

  const admin = await Admin.findOne({ email }).select("+password");
  if (!admin) {
    throw new AppError(404, "Admin not found. Please sign up first");
  }

  const isMatch = await bcrypt.compare(password, admin.password);
  if (!isMatch) {
    throw new AppError(401, "Password is incorrect");
  }

  const token = signAdminToken(admin);

  return {
    token,
    admin: { ...admin.toObject(), password: undefined },
  };
};

export const updateAdminById = async (
  id,
  { name, email, mobileNumber, password, confirmPassword }
) => {
  if (!mongoose.Types.ObjectId.isValid(id)) {
    throw new AppError(400, "Invalid admin ID format");
  }

  const admin = await Admin.findById(id);
  if (!admin) {
    throw new AppError(404, "Admin not found");
  }

  const updates = {};
  if (name) updates.name = name;
  if (mobileNumber) updates.mobileNumber = mobileNumber;

  if (email && email !== admin.email) {
    const emailExists = await Admin.findOne({ email, _id: { $ne: id } });
    if (emailExists) {
      throw new AppError(400, "Email already in use by another admin");
    }
    updates.email = email;
  }

  if (password) {
    if (password !== confirmPassword) {
      throw new AppError(400, "Passwords do not match");
    }

    const errors = validatePassword(password);
    if (errors.length > 0) {
      throw new AppError(400, errors.join(", "));
    }

    const salt = await bcrypt.genSalt(10);
    updates.password = await bcrypt.hash(password, salt);
  }

  const updatedAdmin = await Admin.findByIdAndUpdate(id, updates, {
    new: true,
    runValidators: true,
  }).select("-password");

  let token = null;
  if (email || password) {
    token = signAdminToken(updatedAdmin);
  }

  return { updatedAdmin, token };
};

/* ------------------------------------------------------------------
   PASSWORD RESET (OTP FLOW)
-------------------------------------------------------------------*/

// Returns one of:
//   { status: "no-admin" }              - no admin with this email (caller should still report generic success)
//   { status: "sent" }                   - OTP generated & emailed
//   { status: "dev-fallback" }           - email failed but we're not in production, OTP is in the logs
// Throws AppError(500, ...) if email fails in production.
export const requestAdminPasswordResetOtp = async (email) => {
  if (!email) {
    throw new AppError(400, "Email is required");
  }

  const admin = await Admin.findOne({ email });
  if (!admin) {
    return { status: "no-admin" };
  }

  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  if (process.env.NODE_ENV !== "production") {
    console.log(
      `🎯 Generated OTP for ${email} at ${new Date().toISOString()}: ${otp}`
    );
  }

  otpStore.set(email, {
    otp,
    createdAt: Date.now(),
    expiresAt: Date.now() + 10 * 60 * 1000, // 10 minutes
    verified: false,
  });

  const emailContent = {
    to: email,
    subject: "Password Reset OTP - Matrimony Admin",
    text: `Your OTP for password reset is: ${otp}\n\nThis OTP will expire in 10 minutes.\n\nIf you didn't request a password reset, please ignore this email.`,
    html: `
      <div style="font-family: Arial, sans-serif; padding: 20px; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px;">
        <div style="text-align: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; color: white; border-radius: 8px 8px 0 0;">
          <h1 style="margin: 0;">Matrimony Admin</h1>
        </div>
        <div style="padding: 30px 20px;">
          <h2 style="color: #333; text-align: center;">Password Reset Request</h2>
          <p style="color: #666; font-size: 16px; line-height: 1.6;">
            You have requested to reset your password. Use the OTP below to complete the process:
          </p>
          <div style="text-align: center; margin: 30px 0;">
            <div style="display: inline-block; padding: 15px 30px; background: #f8f9fa; border: 2px dashed #667eea; border-radius: 8px; font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #333;">
              ${otp}
            </div>
          </div>
          <p style="color: #ff6b6b; font-size: 14px; text-align: center;">
            ⚠️ This OTP will expire in 10 minutes
          </p>
          <p style="color: #666; font-size: 14px; line-height: 1.6;">
            If you didn't request this password reset, please ignore this email. Your account remains secure.
          </p>
        </div>
        <div style="background: #f8f9fa; padding: 15px; text-align: center; border-radius: 0 0 8px 8px;">
          <p style="color: #999; font-size: 12px; margin: 0;">
            This is an automated message. Please do not reply to this email.
          </p>
        </div>
      </div>
    `,
  };

  console.log(
    `📤 Attempting to send email to ${email} at ${new Date().toISOString()}`
  );

  try {
    const result = await sendEmail(emailContent);
    console.log(
      `✅ Email sent successfully to ${email} at ${new Date().toISOString()}: ${
        result.messageId
      }`
    );
    return { status: "sent" };
  } catch (emailError) {
    console.error(
      `❌ Email sending failed for ${email} at ${new Date().toISOString()}:`,
      emailError
    );
    if (process.env.NODE_ENV === "production") {
      throw new AppError(500, "Failed to send OTP email. Please try again later or contact support.", {
        error: emailError.message,
      });
    }
    return { status: "dev-fallback" };
  }
};

export const verifyAdminOtp = (email, otp) => {
  if (!email || !otp) {
    throw new AppError(400, "Email and OTP are required");
  }

  const record = otpStore.get(email);

  if (process.env.NODE_ENV !== "production") {
    console.log(
      `🔍 OTP verification attempt for ${email} at ${new Date().toISOString()}:`,
      {
        storedOTP: record?.otp,
        enteredOTP: otp,
        expiresAt: record?.expiresAt,
        currentTime: Date.now(),
      }
    );
  } else {
    console.log(
      `🔍 OTP verification attempt for ${email} at ${new Date().toISOString()}`
    );
  }

  if (!record) {
    throw new AppError(400, "OTP not found or expired");
  }

  if (Date.now() > record.expiresAt) {
    otpStore.delete(email);
    throw new AppError(400, "OTP has expired");
  }

  if (record.otp !== otp) {
    throw new AppError(400, "Incorrect OTP");
  }

  otpStore.set(email, { ...record, verified: true });
  console.log(
    `✅ OTP verified successfully for ${email} at ${new Date().toISOString()}`
  );
};

export const resetAdminPassword = async (email, otp, newPassword) => {
  if (!email || !otp || !newPassword) {
    throw new AppError(400, "Email, OTP, and new password are required");
  }

  const record = otpStore.get(email);
  if (!record || !record.verified || record.otp !== otp) {
    throw new AppError(400, "Invalid or unverified OTP");
  }

  if (Date.now() > record.expiresAt) {
    otpStore.delete(email);
    throw new AppError(400, "OTP has expired");
  }

  const admin = await Admin.findOne({ email });
  if (!admin) {
    throw new AppError(404, "Admin user not found");
  }

  const errors = validatePassword(newPassword);
  if (errors.length > 0) {
    throw new AppError(400, errors.join(", "));
  }

  const hashedPassword = await bcrypt.hash(newPassword, 10);
  await Admin.findOneAndUpdate(
    { email },
    { password: hashedPassword, updatedAt: new Date() },
    { runValidators: false, new: true }
  );

  otpStore.delete(email);

  try {
    await sendEmail({
      to: email,
      subject: "Password Reset Successful - Matrimony Admin",
      text: `Your password has been successfully reset. If you did not make this change, please contact support immediately.`,
      html: `
        <div style="font-family: Arial, sans-serif; padding: 20px; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #28a745;">Password Reset Successful</h2>
          <p>Your password has been successfully updated.</p>
          <p style="color: #dc3545;"><strong>If you did not make this change, contact support immediately.</strong></p>
        </div>
      `,
    });
    console.log(
      `✅ Password reset confirmation email sent to ${email} at ${new Date().toISOString()}`
    );
  } catch (emailError) {
    console.error(
      `❌ Confirmation email failed for ${email} at ${new Date().toISOString()}:`,
      emailError
    );
  }

  console.log(
    `✅ Password reset successfully for ${email} at ${new Date().toISOString()}`
  );
};

export const changeAdminPassword = async (
  adminId,
  { currentPassword, newPassword, confirmNewPassword }
) => {
  if (!adminId || adminId === "undefined" || adminId === "null") {
    throw new AppError(400, "Valid Admin ID is required in the URL");
  }

  if (!currentPassword || !newPassword || !confirmNewPassword) {
    throw new AppError(400, "All password fields are required");
  }

  if (newPassword !== confirmNewPassword) {
    throw new AppError(400, "New passwords do not match");
  }

  if (currentPassword === newPassword) {
    throw new AppError(400, "New password cannot be the same as current password");
  }

  const admin = await Admin.findById(adminId).select("+password");
  if (!admin) {
    throw new AppError(404, "Admin not found");
  }

  const isCurrentPasswordValid = await admin.comparePassword(currentPassword);
  if (!isCurrentPasswordValid) {
    throw new AppError(400, "Current password is incorrect");
  }

  admin.password = newPassword;
  await admin.save();
};

/* ------------------------------------------------------------------
   USER PROFILE UPDATE (BY ADMIN)
-------------------------------------------------------------------*/

const IMAGE_FIELDS = [
  "aadhaarFrontphoto",
  "aadhaarBackphoto",
  "panFrontphoto",
  "panBackphoto",
  "passportFrontphoto",
  "passportBackphoto",
  "photoFulls",
  "highestEducationalDoc",
  "castecertificate",
  "photoCloseup",
  "photoFull",
  "familyPhoto",
];

export const updateUserProfileByAdmin = async (userId, body, files) => {
  if (!userId || !mongoose.Types.ObjectId.isValid(userId)) {
    throw new AppError(400, "Valid User ID is required");
  }

  const userRegistration = parseIfString(body.userRegistration);
  const personalDetail = parseIfString(body.personalDetail);
  const educationalDetail = parseIfString(body.educationalDetail);
  const familyDetails = parseIfString(body.familyDetails);
  const astrologyDetails = parseIfString(body.astrologyDetails);
  const partnerDetail = parseIfString(body.partnerDetail);
  const documentDetails = parseIfString(body.documentDetails);

  const currentUser = await Matrimony.findById(userId);
  if (!currentUser) {
    throw new AppError(404, "User not found");
  }

  const updateData = {};

  if (Object.keys(userRegistration).length > 0) {
    const { password, confirmPassword, ...safeUserRegistration } =
      userRegistration;
    const cleanedUserRegistration = cleanNumericFields(safeUserRegistration);

    if (Object.keys(cleanedUserRegistration).length > 0) {
      updateData.userRegistration = mergeObjectsSafely(
        currentUser.userRegistration,
        cleanedUserRegistration
      );

      if (currentUser.userRegistration?.password) {
        updateData.userRegistration.password =
          currentUser.userRegistration.password;
      }
      if (currentUser.userRegistration?.confirmPassword) {
        updateData.userRegistration.confirmPassword =
          currentUser.userRegistration.confirmPassword;
      }
    }
  }

  if (Object.keys(personalDetail).length > 0) {
    updateData.personalDetail = mergeObjectsSafely(
      currentUser.personalDetail,
      personalDetail
    );
  }

  if (Object.keys(educationalDetail).length > 0) {
    updateData.educationalDetail = mergeObjectsSafely(
      currentUser.educationalDetail,
      educationalDetail
    );
  }

  if (Object.keys(familyDetails).length > 0) {
    updateData.familyDetails = mergeObjectsSafely(
      currentUser.familyDetails,
      familyDetails
    );
  }

  if (Object.keys(astrologyDetails).length > 0) {
    updateData.astrologyDetails = mergeObjectsSafely(
      currentUser.astrologyDetails,
      astrologyDetails
    );
  }

  if (Object.keys(partnerDetail).length > 0) {
    updateData.partnerDetail = mergeObjectsSafely(
      currentUser.partnerDetail,
      partnerDetail
    );
  }

  const uploadedImages = {};

  if (files) {
    for (const field of IMAGE_FIELDS) {
      if (files[field]?.[0]) {
        const file = files[field][0];
        try {
          const filePath = path.resolve(file.path);
          const fileBuffer = await fs.readFile(filePath);
          const base64Image = `data:${
            file.mimetype
          };base64,${fileBuffer.toString("base64")}`;

          const result = await cloudinary.uploader.upload(base64Image, {
            folder: "matrimony_uploads",
            resource_type: "image",
          });
          uploadedImages[field] = result.secure_url;

          await fs
            .unlink(filePath)
            .catch((err) => console.warn(`Failed to delete ${filePath}:`, err));
        } catch (error) {
          console.error(`Error uploading ${field}:`, error);
          throw new AppError(400, `Failed to upload ${field}`, {
            error:
              process.env.NODE_ENV === "development" ? error.message : undefined,
          });
        }
      }
    }
  }

  if (
    Object.keys(uploadedImages).length > 0 ||
    Object.keys(documentDetails).length > 0
  ) {
    updateData.documentDetails = mergeObjectsSafely(currentUser.documentDetails, {
      ...documentDetails,
      ...uploadedImages,
    });
  }

  console.log("Update data prepared:", Object.keys(updateData));

  if (Object.keys(updateData).length === 0) {
    throw new AppError(400, "No valid data provided for update");
  }

  const updatedUser = await Matrimony.findByIdAndUpdate(
    userId,
    { $set: updateData },
    { new: true, runValidators: false }
  );

  if (!updatedUser) {
    throw new AppError(404, "User not found after update attempt");
  }

  const userResponse = updatedUser.toObject();
  if (userResponse.userRegistration) {
    userResponse.userRegistration.password = undefined;
    userResponse.userRegistration.confirmPassword = undefined;
  }

  return userResponse;
};