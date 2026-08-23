// src/services/adminDashboardService.js
import Admin from "../admin/admin.schema.js";
import Matrimony from "../brideGroom/bridegroom.schema.js";
import XLSX from "xlsx";
import dayjs from "dayjs"; // lightweight date parsing
import { sendEmail } from "../../utils/sendEmail.js";

// Generic service-layer error carrying an HTTP status code and optional extra payload
export class AppError extends Error {
  constructor(status, message, extra = {}) {
    super(message);
    this.name = "AppError";
    this.status = status;
    this.extra = extra;
  }
}

/* ------------------------------------------------------------------
   DASHBOARD STATS
-------------------------------------------------------------------*/

export const getTotalUsersCount = async () => {
  const totalUsers = await Matrimony.countDocuments();
  console.log(totalUsers);
  return totalUsers;
};

export const getGroomsStats = async () => {
  const totalGrooms = await Matrimony.countDocuments({
    "personalDetail.gender": "Groom",
  });
  console.log("totalGrooms", totalGrooms);

  const singleGrooms = await Matrimony.countDocuments({
    "personalDetail.gender": "Groom",
    "personalDetail.maritalStatus": "Single",
  });
  console.log("singleGrooms", singleGrooms);

  const divorcedGrooms = await Matrimony.countDocuments({
    "personalDetail.gender": "Groom",
    "personalDetail.maritalStatus": "Divorced",
  });
  console.log("divorcedGrooms", divorcedGrooms);

  const widowedGrooms = await Matrimony.countDocuments({
    "personalDetail.gender": "Groom",
    "personalDetail.maritalStatus": "Widowed",
  });
  console.log("widowedGrooms", widowedGrooms);

  return { totalGrooms, widowedGrooms, divorcedGrooms, singleGrooms };
};

export const getBrideStats = async () => {
  const totalBride = await Matrimony.countDocuments({
    "personalDetail.gender": "Bride",
  });
  console.log("totalBride", totalBride);

  const singleBride = await Matrimony.countDocuments({
    "personalDetail.gender": "Bride",
    "personalDetail.maritalStatus": "Single",
  });
  console.log("singleBride", singleBride);

  const divorcedBride = await Matrimony.countDocuments({
    "personalDetail.gender": "Bride",
    "personalDetail.maritalStatus": "Divorced",
  });
  console.log("divorcedBride", divorcedBride);

  const widowedBride = await Matrimony.countDocuments({
    "personalDetail.gender": "Bride",
    "personalDetail.maritalStatus": "Widowed",
  });
  console.log("widowedBride", widowedBride);

  return { totalBride, widowedBride, divorcedBride, singleBride };
};

export const getRecentRegistrations = async (limit = 50) => {
  const newRegistrations = await Matrimony.find({})
    .sort({ createdAt: -1 })
    .limit(limit);
  console.log(newRegistrations);
  return newRegistrations;
};

const MONTHS = [
  "",
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

export const getUserGrowthStats = async () => {
  const monthlyData = await Matrimony.aggregate([
    {
      $group: {
        _id: {
          year: { $year: "$createdAt" },
          month: { $month: "$createdAt" },
        },
        totalUsers: { $sum: 1 },
      },
    },
    { $sort: { "_id.year": 1, "_id.month": 1 } },
  ]);

  const formattedData = monthlyData.map((item) => ({
    year: item._id.year,
    month: MONTHS[item._id.month],
    totalUsers: item.totalUsers,
  }));

  const now = new Date();
  const currentMonth = now.getMonth() + 1;
  const currentYear = now.getFullYear();

  const currentMonthCount = await Matrimony.countDocuments({
    createdAt: {
      $gte: new Date(currentYear, currentMonth - 1, 1),
      $lt: new Date(currentYear, currentMonth, 1),
    },
  });
  console.log("currentMonthCount");

  return {
    monthlyData: formattedData,
    currentMonth: {
      year: currentYear,
      month: MONTHS[currentMonth],
      totalUsers: currentMonthCount,
    },
  };
};

/* ------------------------------------------------------------------
   APPROVAL WORKFLOW
-------------------------------------------------------------------*/

export const getPendingUsers = async () => {
  const allUsers = await Matrimony.find();
  const allPendingUsers = allUsers.filter(
    (user) => user.approvalStatus === "Pending"
  );
  console.log("allPendingUsers", allPendingUsers);
  return allPendingUsers;
};

export const getApprovedUsers = async () => {
  const allUsers = await Matrimony.find();
  const allApproveUsers = allUsers.filter(
    (user) => user.approvalStatus === "Approved"
  );
  console.log("allApprovUsers", allApproveUsers);
  return allApproveUsers;
};

export const getDeniedUsers = async () => {
  const allDenyUsers = await Matrimony.find({ approvalStatus: "Denied" });
  console.log("allDenyUsers", allDenyUsers);
  return allDenyUsers;
};

// Approves a user and emails them a notification.
export const approveUserAndNotify = async (userId, approvedBy) => {
  const approveUser = await Matrimony.findByIdAndUpdate(
    userId,
    { approvalStatus: "Approved" },
    { new: true }
  );

  console.log("approveUser", approveUser);

  if (!approveUser) {
    throw new AppError(404, "User not found");
  }

  const email = approveUser.userRegistration?.email || approveUser.email;
  const fullName =
    approveUser.userRegistration?.fullName ||
    approveUser.name ||
    approveUser.fullName;
  const approvedUserId = approveUser._id;

  if (!email) {
    throw new AppError(400, "Cannot send email: user does not have a valid email");
  }

  const frontendProfileLink = `http://localhost:5173/profile/${approvedUserId}`;
  const frontendBrowseLink = `http://localhost:5173/matches`;
  const frontendDashboardLink = `http://localhost:5173/user-home`;

  try {
    await sendEmail({
      to: email,
      subject: "🎉 Congratulations! Your Profile Has Been Approved",
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <div style="background: linear-gradient(135deg, #4CAF50, #45a049); padding: 30px; text-align: center; border-radius: 8px 8px 0 0;">
            <h1 style="color: white; margin: 0; font-size: 28px;">🎉 Profile Approved!</h1>
            <p style="color: white; margin: 10px 0 0 0; font-size: 16px; opacity: 0.9;">Welcome to our matrimony community</p>
          </div>
          
          <div style="padding: 30px; background: #ffffff;">
            <p>Hi <strong style="color: #2c3e50;">${fullName}</strong>,</p>
            
            <div style="background: #e8f5e8; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #4CAF50;">
              <p style="margin: 0; color: #2d5016; font-size: 16px;">
                <strong>Great news!</strong> Your profile has been reviewed and approved by our admin team. 
                You are now part of our trusted matrimony community.
              </p>
            </div>

            <div style="background-color: #f8f9fa; padding: 25px; border-radius: 8px; margin: 25px 0;">
              <h3 style="color: #495057; margin-top: 0; text-align: center;">🚀 Start Your Journey</h3>
              
              <div style="margin-bottom: 25px;">
                <h4 style="color: #4CAF50; margin-bottom: 12px;">View Your Live Profile</h4>
                <p style="margin-bottom: 15px;">See how your profile appears to other members:</p>
                <div style="text-align: center; margin: 20px 0;">
                  <a href="${frontendProfileLink}" 
                     style="background-color: #4CAF50; color: white; padding: 14px 32px; 
                            text-decoration: none; border-radius: 6px; display: inline-block;
                            font-weight: bold; font-size: 16px; box-shadow: 0 2px 4px rgba(76, 175, 80, 0.3);">
                    👀 View My Profile
                  </a>
                </div>
                <p style="font-size: 14px; color: #6c757d; text-align: center;">
                  <strong>Direct Link:</strong><br>
                  <a href="${frontendProfileLink}" style="color: #007bff; word-break: break-all;">
                    ${frontendProfileLink}
                  </a>
                </p>
              </div>

              <div style="border-top: 2px dashed #dee2e6; padding-top: 25px;">
                <h4 style="color: #2196F3; margin-bottom: 12px;">Browse Potential Matches</h4>
                <p style="margin-bottom: 15px;">Start exploring compatible profiles now:</p>
                <div style="text-align: center; margin: 15px 0;">
                  <a href="${frontendBrowseLink}"
                     style="background-color: #2196F3; color: white; padding: 12px 28px;
                            text-decoration: none; border-radius: 6px; display: inline-block;
                            font-weight: bold; box-shadow: 0 2px 4px rgba(33, 150, 243, 0.3);">
                    🔍 Browse Matches
                  </a>
                </div>
              </div>

              <div style="border-top: 2px dashed #dee2e6; padding-top: 25px;">
                <h4 style="color: #9C27B0; margin-bottom: 12px;">Access Your Dashboard</h4>
                <p style="margin-bottom: 15px;">Manage your profile, matches, and settings:</p>
                <div style="text-align: center; margin: 15px 0;">
                  <a href="${frontendDashboardLink}"
                     style="background-color: #9C27B0; color: white; padding: 12px 28px;
                            text-decoration: none; border-radius: 6px; display: inline-block;
                            font-weight: bold; box-shadow: 0 2px 4px rgba(156, 39, 176, 0.3);">
                    📊 My Dashboard
                  </a>
                </div>
              </div>
            </div>

            <div style="background-color: #e3f2fd; padding: 20px; border-radius: 8px; border: 1px solid #bbdefb; margin: 20px 0;">
              <h4 style="color: #1565c0; margin-top: 0;">✨ What's Next?</h4>
              <ul style="color: #1565c0; margin-bottom: 0;">
                <li><strong>Complete your profile</strong> - Add more details to get better matches</li>
                <li><strong>Set your preferences</strong> - Tell us what you're looking for</li>
                <li><strong>Browse profiles</strong> - Discover potential matches</li>
                <li><strong>Send interests</strong> - Connect with people you like</li>
                <li><strong>Receive matches</strong> - Get daily compatible suggestions</li>
              </ul>
            </div>

            <div style="background-color: #fff8e1; padding: 18px; border-radius: 8px; border: 1px solid #ffecb3; margin: 20px 0;">
              <h4 style="color: #ff8f00; margin-top: 0;">💡 Tips for Success</h4>
              <ul style="color: #ff8f00; margin-bottom: 0;">
                <li>Keep your profile information updated</li>
                <li>Upload clear, recent photographs</li>
                <li>Be responsive to incoming interests</li>
                <li>Use advanced search filters to find better matches</li>
                <li>Verify your contact information</li>
              </ul>
            </div>

            <div style="text-align: center; margin: 30px 0 20px 0; padding: 20px; background: #f8f9fa; border-radius: 8px;">
              <p style="margin: 0; color: #6c757d; font-size: 14px;">
                <strong>Need assistance?</strong> Our support team is here to help you.<br>
                Contact us at: <a href="mailto:support@matrimony.com" style="color: #007bff;">support@matrimony.com</a>
              </p>
            </div>

            <p style="text-align: center; margin-top: 30px;">
              Best regards,<br>
              <strong style="color: #4CAF50;">Matrimony Team</strong>
            </p>
          </div>

          <div style="background: #2c3e50; padding: 20px; text-align: center; border-radius: 0 0 8px 8px;">
            <p style="color: #ecf0f1; margin: 0; font-size: 12px;">
              &copy; ${new Date().getFullYear()} Matrimony Platform. All rights reserved.<br>
              This is an automated message. Please do not reply to this email.
            </p>
          </div>
        </div>
      `,
      text: `
CONGRATULATIONS! YOUR PROFILE HAS BEEN APPROVED

Hi ${fullName},

Great news! Your profile has been reviewed and approved by our admin team. 
You are now part of our trusted matrimony community.

START YOUR JOURNEY:

View Your Live Profile:
${frontendProfileLink}

Browse Potential Matches:
${frontendBrowseLink}

Access Your Dashboard:
${frontendDashboardLink}

WHAT'S NEXT?
• Complete your profile - Add more details to get better matches
• Set your preferences - Tell us what you're looking for
• Browse profiles - Discover potential matches
• Send interests - Connect with people you like
• Receive matches - Get daily compatible suggestions

TIPS FOR SUCCESS:
• Keep your profile information updated
• Upload clear, recent photographs
• Be responsive to incoming interests
• Use advanced search filters to find better matches
• Verify your contact information

Need assistance? Contact our support team: support@matrimony.com

Best regards,
Matrimony Team

© ${new Date().getFullYear()} Matrimony Platform. All rights reserved.
This is an automated message. Please do not reply to this email.
        `,
    });

    console.log(`✅ Approval email sent successfully to ${email}`);
  } catch (emailError) {
    console.error("Failed to send approval email:", emailError);
    throw new AppError(
      500,
      `User approved but failed to send email: ${emailError.message}`,
      { approveUser }
    );
  }

  console.log(`✅ User profile approved successfully`, {
    userId: approvedUserId,
    email,
    fullName,
    approvedBy: approvedBy || "admin",
    timestamp: new Date().toISOString(),
  });

  return {
    approveUser: {
      id: approveUser._id,
      name: fullName,
      email,
      approvalStatus: approveUser.approvalStatus,
      approvedAt: new Date().toISOString(),
    },
    frontendLinks: {
      profile: frontendProfileLink,
      browse: frontendBrowseLink,
      dashboard: frontendDashboardLink,
    },
  };
};

// Denies a user and emails them instructions to update/re-register.
export const denyUserAndNotify = async (userId) => {
  const denyUser = await Matrimony.findByIdAndUpdate(
    userId,
    { approvalStatus: "Denied" },
    { new: true }
  );

  console.log("denyuser", denyUser);

  if (!denyUser) {
    throw new AppError(404, "User not found");
  }

  const email = denyUser.userRegistration.email;
  const fullName = denyUser.userRegistration.fullName;
  const deniedUserId = denyUser._id;

  if (!email) {
    throw new AppError(400, "Cannot send email: user does not have a valid email");
  }

  const frontendUpdateLink = `http://localhost:5173/updateprofile/${deniedUserId}`;
  const frontendRegisterLink = `http://localhost:5174/register`;

  try {
    await sendEmail({
      to: email,
      subject: "Action Required: Your Profile Was Not Approved",
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #d9534f;">Profile Update Required</h2>
          <p>Hi <strong>${fullName}</strong>,</p>
          <p>Your profile has been reviewed by the admin and requires some updates before it can be approved.</p>
          
          <div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;">
            <h3 style="color: #495057; margin-top: 0;">Choose Your Update Method:</h3>
            
            <div style="margin-bottom: 20px;">
              <h4 style="color: #d9534f; margin-bottom: 10px;">Option 1: Update Existing Profile (Recommended)</h4>
              <p style="margin-bottom: 10px;">Click the button below to update your existing profile. Your current information will be pre-filled for easy editing:</p>
              <div style="text-align: center; margin: 20px 0;">
                <a href="${frontendUpdateLink}" 
                   style="background-color: #d9534f; color: white; padding: 15px 30px; 
                          text-decoration: none; border-radius: 5px; display: inline-block;
                          font-weight: bold; font-size: 16px;">
                  📝 Update My Profile
                </a>
              </div>
              <p style="font-size: 14px; color: #6c757d; text-align: center;">
                <strong>Direct Link:</strong><br>
                <a href="${frontendUpdateLink}" style="color: #007bff; word-break: break-all;">
                  ${frontendUpdateLink}
                </a>
              </p>
            </div>

            <div style="border-top: 2px solid #dee2e6; padding-top: 20px;">
              <h4 style="color: #5bc0de; margin-bottom: 10px;">Option 2: Create New Profile</h4>
              <p style="margin-bottom: 10px;">If you prefer to start completely fresh with a new registration:</p>
              <div style="text-align: center; margin: 15px 0;">
                <a href="${frontendRegisterLink}" 
                   style="background-color: #5bc0de; color: white; padding: 12px 24px; 
                          text-decoration: none; border-radius: 5px; display: inline-block;
                          font-weight: bold;">
                  🆕 Create New Profile
                </a>
              </div>
              <p style="font-size: 14px; color: #6c757d; text-align: center;">
                <strong>Direct Link:</strong><br>
                <a href="${frontendRegisterLink}" style="color: #007bff;">
                  ${frontendRegisterLink}
                </a>
              </p>
            </div>
          </div>

          <div style="background-color: #fff3cd; padding: 15px; border-radius: 5px; border: 1px solid #ffeaa7; margin: 20px 0;">
            <h4 style="color: #856404; margin-top: 0;">💡 Why Update Your Existing Profile?</h4>
            <ul style="color: #856404; margin-bottom: 0;">
              <li>Your current information is already pre-filled</li>
              <li>Faster approval process</li>
              <li>Keep your profile history</li>
              <li>Automatically resubmitted for review after update</li>
            </ul>
          </div>

          <div style="background-color: #d1ecf1; padding: 15px; border-radius: 5px; border: 1px solid #bee5eb;">
            <h4 style="color: #0c5460; margin-top: 0;">📋 What to Update?</h4>
            <ul style="color: #0c5460; margin-bottom: 0;">
              <li>Review all personal information</li>
              <li>Update any incomplete sections</li>
              <li>Verify contact details</li>
              <li>Ensure all documents are clear and valid</li>
            </ul>
          </div>

          <p style="margin-top: 20px; text-align: center;">
            <strong>Need help?</strong> Contact our support team if you have any questions.
          </p>
          
          <br>
          <p style="text-align: center;">Best regards,<br><strong>Matrimony Team</strong></p>
        </div>
      `,
      text: `
ACTION REQUIRED: Your Profile Was Not Approved

Hi ${fullName},

Your profile has been reviewed by the admin and requires some updates before it can be approved.

UPDATE OPTIONS:

Option 1: Update Existing Profile (Recommended)
Use this link to update your existing profile. Your current information will be pre-filled for easy editing:
${frontendUpdateLink}

Option 2: Create New Profile
If you prefer to start fresh with a new registration:
${frontendRegisterLink}

Why Update Your Existing Profile?
- Your current information is already pre-filled
- Faster approval process
- Keep your profile history
- Automatically resubmitted for review after update

What to Update?
- Review all personal information
- Update any incomplete sections
- Verify contact details
- Ensure all documents are clear and valid

Need help? Contact our support team.

Best regards,
Matrimony Team
        `,
    });
  } catch (emailError) {
    console.error("Failed to send email:", emailError);
    throw new AppError(500, `Failed to send email: ${emailError.message}`);
  }

  return { denyUser, frontendUpdateLink };
};

/* ------------------------------------------------------------------
   EXCEL BULK IMPORT
-------------------------------------------------------------------*/

const toBoolean = (val) =>
  val === true || val?.toString().toLowerCase() === "yes";

const mapImportance = (val) =>
  ({ "Not Important": 0, "Somewhat Important": 1, "Very Important": 2 }[val] ??
    0);

const PROFILE_CREATED_FOR_ENUM = ["Self", "Son", "Daughter", "Brother", "Sister"];
const GENDER_ENUM = ["Groom", "Bride", "Other"];

const validatePassword = (pwd) =>
  /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/.test(pwd);

const parseDate = (val, rowNumber) => {
  if (!val) throw new Error(`Row ${rowNumber}: dateOfBirth is required`);
  const date = dayjs(val);
  if (!date.isValid())
    throw new Error(`Row ${rowNumber}: Invalid dateOfBirth format`);
  return date.toDate();
};

// Parses & validates a single Excel row into the nested Matrimony shape.
// Throws a plain Error (with the row-prefixed message) on validation failure.
const buildUserFromRow = (row, rowNumber) => {
  const nameRegex = /^[A-Za-z\s]+$/;
  if (!row.fullName || !nameRegex.test(row.fullName.trim())) {
    throw new Error(
      `Row ${rowNumber}: fullName must contain only alphabets and spaces`
    );
  }

  const userRegistration = {
    fullName: row.fullName,
    dateOfBirth: parseDate(row.dateOfBirth, rowNumber),
    phoneNumber: row.phoneNumber,
    email: row.email,
    password: row.password,
    confirmPassword: row.confirmPassword,
    profileCreatedFor: row.profileCreatedFor,
    country: row.country,
    state: row.state,
    district: row.district,
    taluka: row.taluka,
    village: row.village,
    address: row.address,
    pincode: row.pincode,
    alternativePhoneNumber: row.alternativePhoneNumber || "",
  };

  const personalDetail = {
    gender: row.gender,
    maritalStatus: row.maritalStatus,
    numberOfChildren: row.numberOfChildren || 0,
    age: Number(row.age),
    height: Number(row.height),
    weight: Number(row.weight),
    drinking: row.drinking || "No",
    smoking: row.smoking || "No",
    diet: row.diet,
    bloodGroup: row.bloodGroup,
    complexionType: row.complexionType,
    hobbies: row.hobbies || "",
    agriculturalLandAcres: row.agriculturalLandAcres || 0,
    descriptionAboutSelf: row.descriptionAboutSelf || "",
    highestEducation: row.highestEducation || "",
    educationField: row.educationField || "",
    universityCollege: row.universityCollege || "",
    profession: row.profession || "",
    bodyType: row.bodyType || "",
    specialCase: row.specialCase || "",
  };

  const astrologyDetails = {
    nakshatra: row.nakshatra,
    charan: row.charan,
    nadi: row.nadi,
    gan: row.gan,
    gotra: row.gotra,
    rashi: row.rashi,
    placeOfBirth: row.placeOfBirth,
    timeOfBirth: row.timeOfBirth,
    caste: row.caste,
    religion: row.religion,
    motherTongue: row.motherTongue,
    isManglik: toBoolean(row.isManglik),
    importanceOfPatrika: mapImportance(row.importanceOfPatrika),
  };

  const partnerDetail = {
    partnerProfession: row.partnerProfession,
    partnerEducation: row.partnerEducation,
    partnerIncome: row.partnerIncome,
    partnerWorkingLocation: row.partnerWorkingLocation,
    partnerDrinking: row.partnerDrinking,
    partnerSmoking: row.partnerSmoking,
    partnerDiet: row.partnerDiet,
    partnerHeight: Number(row.partnerHeight),
    partnerComplexionType: row.partnerComplexionType,
    partnerMaritalStatus: row.partnerMaritalStatus,
    wantsWorkingPartner: toBoolean(row.wantsWorkingPartner),
  };

  if (!userRegistration.fullName)
    throw new Error(`Row ${rowNumber}: fullName is required`);

  if (!userRegistration.phoneNumber)
    throw new Error(`Row ${rowNumber}: phoneNumber is required`);

  if (!userRegistration.password)
    throw new Error(`Row ${rowNumber}: password is required`);

  if (!validatePassword(userRegistration.password))
    throw new Error(
      `Row ${rowNumber}: Password must contain 8 chars, uppercase, lowercase, number`
    );

  if (userRegistration.password !== row.confirmPassword)
    throw new Error(`Row ${rowNumber}: confirmPassword does not match password`);

  if (!PROFILE_CREATED_FOR_ENUM.includes(userRegistration.profileCreatedFor))
    throw new Error(`Row ${rowNumber}: Invalid profileCreatedFor`);

  if (!GENDER_ENUM.includes(personalDetail.gender))
    throw new Error(`Row ${rowNumber}: Invalid gender`);

  ["diet", "bloodGroup", "complexionType"].forEach((field) => {
    if (!personalDetail[field])
      throw new Error(`Row ${rowNumber}: personalDetail.${field} is required`);
  });

  [
    "nakshatra",
    "charan",
    "nadi",
    "gan",
    "gotra",
    "rashi",
    "placeOfBirth",
    "timeOfBirth",
    "caste",
    "religion",
    "motherTongue",
  ].forEach((field) => {
    if (!astrologyDetails[field])
      throw new Error(`Row ${rowNumber}: astrologyDetails.${field} is required`);
  });

  [
    "partnerProfession",
    "partnerEducation",
    "partnerIncome",
    "partnerWorkingLocation",
    "partnerDrinking",
    "partnerSmoking",
    "partnerDiet",
    "partnerHeight",
    "partnerComplexionType",
    "partnerMaritalStatus",
  ].forEach((field) => {
    if (partnerDetail[field] === undefined || partnerDetail[field] === "")
      throw new Error(`Row ${rowNumber}: partnerDetail.${field} is required`);
  });

  return { userRegistration, personalDetail, astrologyDetails, partnerDetail };
};

// Bulk-imports users from an uploaded Excel file.
// Throws AppError(400, ...) if there's no file or too many rows.
// Returns { insertedCount, errors }.
export const importUsersFromExcel = async (file) => {
  if (!file) {
    throw new AppError(400, "Excel file is required");
  }

  const workbook = XLSX.readFile(file.path);
  const sheet = workbook.Sheets[workbook.SheetNames[0]];
  const rows = XLSX.utils.sheet_to_json(sheet);

  if (rows.length > 50) {
    throw new AppError(400, "You can only upload a maximum of 50 users at a time");
  }

  const newUsers = [];
  const errors = [];
  const dbUsers = await Matrimony.find({}, { "userRegistration.email": 1 });
  const existingEmails = new Set(
    dbUsers.map((u) => u?.userRegistration?.email).filter(Boolean)
  );

  for (const [index, row] of rows.entries()) {
    const rowNumber = index + 2; // Excel headers are row 1

    try {
      if (row.email && existingEmails.has(row.email)) {
        errors.push({
          row: rowNumber,
          message: `Row ${rowNumber}: email '${row.email}' already registered, skipped`,
        });
        continue;
      }

      newUsers.push(buildUserFromRow(row, rowNumber));
    } catch (err) {
      errors.push({ row: rowNumber, message: err.message });
    }
  }

  if (newUsers.length > 0) {
    try {
      const testDoc = new Matrimony(newUsers[0]);
      const validationError = testDoc.validateSync();

      if (validationError) {
        console.error("❌ VALIDATION ERROR:", validationError.errors);
        throw new AppError(400, "Schema validation failed", {
          errors: validationError.errors,
        });
      }

      const result = await Matrimony.insertMany(newUsers, {
        ordered: true,
        rawResult: true,
      });
      console.log("RAW INSERT RESULT:", result);
      console.log("Inserted count:", result.length);
    } catch (err) {
      if (err instanceof AppError) throw err;
      console.error("💥 MONGOOSE INSERT ERROR 💥");
      console.error(err);
    }
  }

  return { insertedCount: newUsers.length, errors };
};

/* ------------------------------------------------------------------
   FILTERING
-------------------------------------------------------------------*/

export const filterUsers = async (filters) => {
  let query = {};

  if (filters.gender) {
    query["personalDetail.gender"] = filters.gender;
  }

  if (filters.minAge || filters.maxAge) {
    query["userRegistration.dateOfBirth"] = {};

    const today = new Date();

    if (filters.minAge) {
      const minAge = parseInt(filters.minAge);
      const maxBirthDateForMinAge = new Date(
        today.getFullYear() - minAge,
        today.getMonth(),
        today.getDate() + 1
      );
      query["userRegistration.dateOfBirth"].$lte = maxBirthDateForMinAge;
    }

    if (filters.maxAge) {
      const maxAge = parseInt(filters.maxAge);
      const minBirthDateForMaxAge = new Date(
        today.getFullYear() - maxAge - 1,
        today.getMonth(),
        today.getDate()
      );
      query["userRegistration.dateOfBirth"].$gte = minBirthDateForMaxAge;
    }
  }

  if (filters.status) {
    query["personalDetail.maritalStatus"] = filters.status;
  }

  if (filters.district) {
    query["userRegistration.district"] = filters.district;
  }

  if (filters.profession) {
    query["educationalDetail.profession"] = filters.profession;
  }

  if (filters.annualIncome) {
    query["educationalDetail.annualIncome"] = {
      $gte: parseInt(filters.annualIncome),
    };
  }

  if (filters.education) {
    query["educationalDetail.educationLevel"] = filters.education;
  }

  if (filters.familyType) {
    query["familyDetails.familyType"] = filters.familyType;
  }

  const users = await Matrimony.find(query)
    .populate("userRegistration")
    .populate("personalDetail")
    .populate("educationalDetail")
    .populate("familyDetails")
    .populate("astrologyDetails");

  return users;
};

export const getFilterOptions = async () => {
  const genders = await Matrimony.distinct("personalDetail.gender");
  const statuses = await Matrimony.distinct("personalDetail.maritalStatus");
  const districts = await Matrimony.distinct("userRegistration.district");
  const professions = await Matrimony.distinct("educationalDetail.profession");
  const annualIncomes = await Matrimony.distinct("educationalDetail.annualIncome");
  const educations = await Matrimony.distinct("educationalDetail.educationLevel");
  const familyTypes = await Matrimony.distinct("familyDetails.familyType");

  const dobRecords = await Matrimony.distinct("userRegistration.dateOfBirth");
  const today = new Date();
  const ages = dobRecords
    .filter(Boolean)
    .map((dob) => {
      const birthDate = new Date(dob);
      const age = today.getFullYear() - birthDate.getFullYear();
      const monthDiff = today.getMonth() - birthDate.getMonth();
      if (
        monthDiff < 0 ||
        (monthDiff === 0 && today.getDate() < birthDate.getDate())
      ) {
        return age - 1;
      }
      return age;
    })
    .filter((age) => age > 0);

  const minAge = Math.min(...ages) || 18;
  const maxAge = Math.max(...ages) || 100;
  const ageOptions = Array.from(
    { length: maxAge - minAge + 1 },
    (_, i) => minAge + i
  );

  return {
    genders: genders.filter(Boolean),
    statuses: statuses.filter(Boolean),
    districts: districts.filter(Boolean),
    professions: professions.filter(Boolean),
    annualIncomes: annualIncomes.filter(Boolean),
    educations: educations.filter(Boolean),
    familyTypes: familyTypes.filter(Boolean),
    ages: ageOptions,
  };
};

/* ------------------------------------------------------------------
   PROFILE CRUD
-------------------------------------------------------------------*/

export const getProfileById = async (id) => {
  const profile = await Matrimony.findById(id);
  if (!profile) {
    throw new AppError(404, "Profile not found");
  }
  return profile;
};

// NOTE: preserves the original's use of a bare `cloudinary` identifier
// (image deletion), which isn't imported anywhere in the source file. If a
// profile actually has image fields with `public_id`, this will throw a
// ReferenceError. Import your configured cloudinary instance here to fix.
export const deleteProfileById = async (id) => {
  const profile = await Matrimony.findById(id);
  if (!profile) {
    throw new AppError(404, "Profile not found");
  }

  const imageFields = [
    "aadhaarFrontphoto",
    "aadhaarBackphoto",
    "panFrontphoto",
    "panBackphoto",
    "passportFrontphoto",
    "passportBackphoto",
    "educationCertificate",
    "highestEducationalDoc",
    "photoCloseup",
    "photoFull",
    "familyPhoto",
  ];

  for (const field of imageFields) {
    if (profile[field] && profile[field].public_id) {
      await cloudinary.uploader.destroy(profile[field].public_id);
    }
  }

  await Matrimony.findByIdAndDelete(id);
};

/* ------------------------------------------------------------------
   ADMIN LOOKUP
-------------------------------------------------------------------*/

export const getAdminInfo = async (adminId) => {
  const admin = await Admin.findById(adminId).select("-password");
  return admin;
};

export const getAllAdmins = async () => {
  return Admin.find({});
};