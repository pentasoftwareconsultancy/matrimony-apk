import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import fs from "fs/promises"; // For reading files from disk
import path from "path"; // For handling file paths
import Matrimony from "../brideGroom/bridegroom.schema.js";
import Admin from "../admin/admin.schema.js";
import { isEmailAllowed } from "../admin/admin.service.js";
import { sendEmail } from "../../utils/sendEmail.js";
import cloudinary from "../../config/cloudinary.js";

// In-memory OTP store (email → otp info)
const otpStore = new Map();

// Clean up expired OTPs every minute
setInterval(() => {
  const now = Date.now();
  for (const [email, record] of otpStore.entries()) {
    if (now > record.expiresAt) {
      console.log(`Cleaning up expired OTP for ${email}`); // Debug log
      otpStore.delete(email);
    }
  }
}, 60 * 1000);

export const cookieOption = {
  maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
  httpOnly: true,
  secure: process.env.NODE_ENV === "production",
  sameSite: process.env.NODE_ENV === "production" ? "none" : "lax",
};

// Fields that must be uploaded/parsed for a registration or profile update
export const IMAGE_FIELDS = [
  "aadhaarFrontphoto",
  "aadhaarBackphoto",
  "panFrontphoto",
  "panBackphoto",
  "passportFrontphoto",
  "passportBackphoto",
  "photoFulls",
  "highestEducationalDoc",
  "castecertificate", // Caste certificate field
  "photoCloseup",
  "photoFull",
  "familyPhoto",
];

// Required fields for userRegistration section
const REQUIRED_USER_REG_FIELDS = [
  "fullName",
  "email",
  "phoneNumber",
  "password",
  "confirmPassword",
  "country",
  "state",
  "district",
  "taluka",
  "village",
  "address",
  "pincode",
  "profileCreatedFor",
  "dateOfBirth",
];

// Password regex that allows special characters
const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;

// Stricter password regex requiring a special character (used for reset flow)
const RESET_PASSWORD_REGEX =
  /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[a-zA-Z\d@$!%*?&]{8,}$/;

// Generic application error carrying an HTTP status code and optional payload
export class AppError extends Error {
  constructor(statusCode, message, extra = {}) {
    super(message);
    this.name = "AppError";
    this.statusCode = statusCode;
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

// Parses every section of the multipart body used by register/update
export const parseRegistrationSections = (body) => {
  const userRegistration = parseIfString(body.userRegistration);
  const personalDetail = parseIfString(body.personalDetail);
  let educationalDetail = parseIfString(body.educationalDetail);
  const familyDetails = parseIfString(body.familyDetails);
  const astrologyDetails = parseIfString(body.astrologyDetails);
  const partnerDetail = parseIfString(body.partnerDetail);
  const documentDetails = parseIfString(body.documentDetails);

  educationalDetail = cleanNumericFields(educationalDetail);

  return {
    userRegistration,
    personalDetail,
    educationalDetail,
    familyDetails,
    astrologyDetails,
    partnerDetail,
    documentDetails,
  };
};

// Validates that all required sections/fields are present for registration.
// Throws AppError(400, ...) on failure.
export const validateRegistrationPayload = (sections, hasFiles) => {
  const {
    userRegistration,
    personalDetail,
    educationalDetail,
    familyDetails,
    astrologyDetails,
    partnerDetail,
    documentDetails,
  } = sections;

  const missingSections = [];
  if (!Object.keys(userRegistration).length)
    missingSections.push("userRegistration");
  if (!Object.keys(personalDetail).length)
    missingSections.push("personalDetail");
  if (!Object.keys(educationalDetail).length)
    missingSections.push("educationalDetail");
  if (!Object.keys(familyDetails).length)
    missingSections.push("familyDetails");
  if (!Object.keys(astrologyDetails).length)
    missingSections.push("astrologyDetails");
  if (!Object.keys(partnerDetail).length)
    missingSections.push("partnerDetail");
  if (!Object.keys(documentDetails).length && !hasFiles)
    missingSections.push("documentDetails");

  if (missingSections.length > 0) {
    throw new AppError(400, "Missing required data sections", {
      missingSections,
    });
  }

  const missingFields = REQUIRED_USER_REG_FIELDS.filter(
    (field) =>
      !(field in userRegistration) ||
      userRegistration[field] === undefined ||
      userRegistration[field] === null ||
      userRegistration[field] === ""
  );

  if (missingFields.length > 0) {
    throw new AppError(400, "Missing required fields in userRegistration", {
      missingFields,
    });
  }
};

// Validates password + confirmPassword + phone number for registration.
// Returns the normalized 10-digit phone number.
export const validateCredentialsAndPhone = (userRegistration) => {
  const { password, confirmPassword, phoneNumber: rawPhoneNumber } =
    userRegistration;

  if (password !== confirmPassword) {
    throw new AppError(400, "Password and confirm password do not match");
  }

  if (!PASSWORD_REGEX.test(password)) {
    throw new AppError(
      400,
      "Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, and one number"
    );
  }

  if (!rawPhoneNumber) {
    throw new AppError(400, "Phone number is required");
  }

  const phoneNumber = String(rawPhoneNumber).replace(/\D/g, "");
  if (!/^\d{10}$/.test(phoneNumber)) {
    throw new AppError(400, "Phone number must be exactly 10 digits");
  }

  return phoneNumber;
};

export const findExistingUserByEmailOrPhone = async (email, phoneNumber) => {
  return Matrimony.findOne({
    $or: [
      { "userRegistration.email": email },
      { "userRegistration.phoneNumber": phoneNumber },
    ],
  });
};

// Uploads any files present in req.files (keyed by IMAGE_FIELDS) to Cloudinary,
// removes the temp file from disk, and returns a map of field -> secure_url.
// Throws AppError(400, ...) with the failing field name if an upload fails.
export const uploadDocumentImages = async (files) => {
  const uploadedImages = {};

  if (!files) return uploadedImages;

  for (const field of IMAGE_FIELDS) {
    if (files[field]?.[0]) {
      const file = files[field][0];
      try {
        const filePath = path.resolve(file.path);
        const fileBuffer = await fs.readFile(filePath);
        const base64Image = `data:${file.mimetype};base64,${fileBuffer.toString(
          "base64"
        )}`;
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

  return uploadedImages;
};

// Full registration flow: validate, upload files, persist user, issue token,
// send welcome email. Returns { token, user }.
export const registerUser = async (body, files) => {
  const sections = parseRegistrationSections(body);
  validateRegistrationPayload(sections, !!files);

  const { userRegistration, documentDetails } = sections;
  const phoneNumber = validateCredentialsAndPhone(userRegistration);

  const existingUser = await findExistingUserByEmailOrPhone(
    userRegistration.email,
    phoneNumber
  );
  if (existingUser) {
    throw new AppError(400, "Email or phone number already registered");
  }

  const uploadedImages = await uploadDocumentImages(files);

  const newUser = new Matrimony({
    userRegistration: {
      ...userRegistration,
      phoneNumber,
      password: userRegistration.password, // Will be hashed by pre-save hook
    },
    personalDetail: sections.personalDetail,
    educationalDetail: sections.educationalDetail,
    familyDetails: sections.familyDetails,
    astrologyDetails: sections.astrologyDetails,
    partnerDetail: sections.partnerDetail,
    documentDetails: {
      ...documentDetails,
      ...uploadedImages,
      castecertificate:
        uploadedImages.castecertificate || documentDetails.castecertificate,
    },
  });

  try {
    await newUser.save();
  } catch (saveError) {
    if (saveError.name === "ValidationError") {
      throw new AppError(400, "Schema validation failed", {
        errors: flattenValidationErrors(saveError),
      });
    }
    throw saveError;
  }

  const token = newUser.jwtToken();

  newUser.userRegistration.password = undefined;
  newUser.userRegistration.confirmPassword = undefined;

  sendEmail({
    to: userRegistration.email,
    subject: "Welcome to Matrimonial Platform",
    text: `Dear ${userRegistration.fullName},\n\nWelcome! Your account was created successfully.\n\nYour caste certificate has been uploaded successfully.`,
  }).catch((emailError) => console.error("Email failed:", emailError));

  return { token, user: newUser };
};

// Full profile-update flow: merge provided sections onto the existing user,
// upload any new files, and persist. Returns the updated user document.
export const updateUserProfile = async (userId, body, files) => {
  const {
    userRegistration,
    personalDetail,
    educationalDetail,
    familyDetails,
    astrologyDetails,
    partnerDetail,
    documentDetails,
  } = parseRegistrationSections(body);

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
      updateData.userRegistration = {
        ...cleanedUserRegistration,
        password: currentUser.userRegistration.password,
        confirmPassword: currentUser.userRegistration.confirmPassword,
      };
    }
  }

  if (Object.keys(personalDetail).length > 0) {
    updateData.personalDetail = cleanNumericFields(personalDetail);
  }

  if (Object.keys(educationalDetail).length > 0) {
    updateData.educationalDetail = cleanNumericFields(educationalDetail);
  }

  if (Object.keys(familyDetails).length > 0) {
    updateData.familyDetails = cleanNumericFields(familyDetails);
  }

  if (Object.keys(astrologyDetails).length > 0) {
    updateData.astrologyDetails = cleanNumericFields(astrologyDetails);
  }

  if (Object.keys(partnerDetail).length > 0) {
    updateData.partnerDetail = cleanNumericFields(partnerDetail);
  }

  const uploadedImages = await uploadDocumentImages(files);

  if (Object.keys(uploadedImages).length > 0) {
    updateData.documentDetails = {
      ...documentDetails,
      ...uploadedImages,
    };
  } else if (Object.keys(documentDetails).length > 0) {
    updateData.documentDetails = cleanNumericFields(documentDetails);
  }

  if (Object.keys(updateData).length === 0) {
    throw new AppError(400, "No valid data provided for update");
  }

  const updatedUser = await Matrimony.findByIdAndUpdate(
    userId,
    { $set: updateData },
    {
      new: true,
      runValidators: false, // Skip validation to avoid regex issues with hashed password
    }
  );

  if (!updatedUser) {
    throw new AppError(404, "User not found");
  }

  updatedUser.userRegistration.password = undefined;
  updatedUser.userRegistration.confirmPassword = undefined;

  return updatedUser;
};

// Authenticates a user by email/password. Returns { token, user }.
export const authenticateUser = async (email, password) => {
  if (!email || !password) {
    throw new AppError(400, "Email and password are required");
  }

  const user = await Matrimony.findOne({
    "userRegistration.email": email,
  }).select("+userRegistration.password");

  if (!user) {
    console.log(`Login attempt for non-existent email: ${email}`);
    throw new AppError(400, "Invalid credentials");
  }

  const storedPassword = user.userRegistration.password;
  let isMatch = false;

  // Try bcrypt comparison first, fall back to plain text comparison
  if (storedPassword && storedPassword.startsWith("$2")) {
    isMatch = await bcrypt.compare(password, storedPassword);
  } else {
    isMatch = password === storedPassword;
  }

  if (!isMatch) {
    console.log(`Password mismatch for user: ${user._id}`);
    throw new AppError(400, "Invalid credentials");
  }

  if (user.approvalStatus !== "Approved") {
    throw new AppError(403, "Your account is waiting for admin approval");
  }

  const token = user.jwtToken();

  user.userRegistration.password = undefined;
  user.userRegistration.confirmPassword = undefined;

  return { token, user };
};

// Unified login: tries the Admin collection first (only if the email is on
// the admin allowlist), falls back to the regular bridegroom/user login.
// Returns { token, user } with a consistent user.role ("admin" | "user") so
// the frontend can gate access with a single login form.
export const authenticateAny = async (email, password) => {
  if (!email || !password) {
    throw new AppError(400, "Email and password are required");
  }

  if (isEmailAllowed(email)) {
    const admin = await Admin.findOne({ email }).select("+password");
    if (admin) {
      const isMatch = await bcrypt.compare(password, admin.password);
      if (isMatch) {
        const token = jwt.sign(
          { id: admin._id, email: admin.email, role: admin.role },
          process.env.JWT_SECRET,
          { expiresIn: "24h" }
        );
        const adminObj = admin.toObject();
        delete adminObj.password;
        return { token, user: { ...adminObj, role: admin.role } };
      }
    }
  }

  const { token, user } = await authenticateUser(email, password);
  const userObj = user.toObject ? user.toObject() : user;
  return { token, user: { ...userObj, role: "user" } };
};

// Generates and emails a 6-digit OTP for password reset, if the email exists.
// Always "succeeds" from the caller's perspective (prevents email enumeration).
export const requestPasswordResetOtp = async (email) => {
  if (!email) {
    throw new AppError(400, "Email is required");
  }

  const user = await Matrimony.findOne({ "userRegistration.email": email });

  if (!user) {
    // Signal to the controller that no email should actually be sent,
    // but the response to the client should still look like success.
    return { sent: false };
  }

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  console.log(`Generated OTP for ${email}: ${otp}`); // Debug log

  otpStore.set(email, {
    otp,
    createdAt: Date.now(),
    expiresAt: Date.now() + 10 * 60 * 1000, // 10 minutes
    verified: false,
  });

  const emailContent = {
    to: email,
    subject: "Password Reset OTP - Matrimony Service",
    text: `Your OTP for password reset is: ${otp}\nIt expires in 10 minutes.\nIf you didn't request this, please ignore this email.`,
    html: `
      <div style="font-family: Arial, sans-serif; padding: 20px; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 10px;">
        <h2 style="color: #333; text-align: center;">Password Reset Request</h2>
        <p>Hello,</p>
        <p>You requested to reset your password. Use the OTP below:</p>
        <div style="text-align: center; margin: 30px 0;">
          <span style="font-size: 32px; font-weight: bold; color: #007BFF; letter-spacing: 5px;">${otp}</span>
        </div>
        <p>This OTP will expire in 10 minutes.</p>
        <p>If you didn't request this, please ignore this email.</p>
        <hr style="border: none; border-top: 1px solid #e0e0e0; margin: 20px 0;">
        <p style="font-size: 12px; color: #666;">This is an automated message, please do not reply.</p>
      </div>
    `,
  };

  console.log(`Sending email to ${email}:`, emailContent); // Debug log
  await sendEmail(emailContent);

  return { sent: true };
};

// Verifies a previously issued OTP. Throws AppError(400, ...) on failure.
export const verifyPasswordResetOtp = (email, otp) => {
  if (!email || !otp) {
    throw new AppError(400, "Email and OTP are required");
  }

  const record = otpStore.get(email);
  console.log(`OTP record for ${email}:`, record); // Debug log

  if (!record) {
    throw new AppError(400, "OTP not found or expired");
  }

  if (Date.now() > record.expiresAt) {
    otpStore.delete(email);
    throw new AppError(400, "OTP has expired");
  }

  if (record.otp !== otp) {
    throw new AppError(400, "Invalid OTP");
  }

  otpStore.set(email, { ...record, verified: true });
};

// Resets a user's password after OTP verification. Throws AppError on failure.
export const resetUserPassword = async (
  email,
  otp,
  newPassword,
  confirmPassword
) => {
  if (!email || !otp || !newPassword || !confirmPassword) {
    throw new AppError(
      400,
      "Email, OTP, new password, and confirm password are required"
    );
  }

  if (newPassword !== confirmPassword) {
    throw new AppError(400, "Passwords do not match");
  }

  if (!RESET_PASSWORD_REGEX.test(newPassword)) {
    throw new AppError(
      400,
      "Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one number, and one special character (@$!%*?&)"
    );
  }

  const record = otpStore.get(email);
  console.log(`OTP record for ${email}:`, record); // Debug log
  if (
    !record ||
    !record.verified ||
    record.otp !== otp ||
    Date.now() > record.expiresAt
  ) {
    otpStore.delete(email);
    throw new AppError(400, "Invalid or unverified OTP");
  }

  const user = await Matrimony.findOne({ "userRegistration.email": email });
  if (!user) {
    throw new AppError(404, "User not found");
  }

  const hashedPassword = await bcrypt.hash(newPassword, 10);

  await Matrimony.updateOne(
    { "userRegistration.email": email },
    { $set: { "userRegistration.password": hashedPassword } }
  );

  otpStore.delete(email);

  await sendEmail({
    to: email,
    subject: "Password Reset Successful - Matrimony Service",
    text: `Your password has been successfully reset. If you did not make this change, please contact support immediately.`,
    html: `
      <div style="font-family: Arial, sans-serif; padding: 20px; max-width: 600px; margin: 0 auto;">
        <h2>Password Reset Complete</h2>
        <p>Your password has been successfully updated.</p>
        <p>If you did not make this change, contact support immediately.</p>
      </div>
    `,
  });
};