import express from "express";
import multer from "multer";
const upload = multer({ dest: "uploads/" });
import { adminuserProfileupdate,adminChangePassword } from "./admin.controller.js";
import {
  adminSignup,
  adminLogin,
  adminLogout,
  updateAdmin,
  forgotPassword, // Changed from adminForgotPassword
  verifyOTP, // Changed from adminVerifyOTP
  resetPassword, // Changed from adminResetPassword
} from "./admin.controller.js";


import {
  totalUsers,
  groomsDetails,
  brideDetails,
  newRegistrations,
  userGrowth,
  getPendingUser,
  approveUser,
  denyUser,
  getDenyUser,
  adminFilterUsers,
  adminFilterOptions,
  getProfileById,
  getApproveUser,
  deleteProfileById,
  getAdminInfo,
  ExcelregisterUsers,
  getadmin
} from "../adminprofile/adminprofile.controller.js";

import authMiddleware from "../../middleware/authMiddleware.js";
import requireRole from "../../middleware/requireRole.js";

const adminRouter = express.Router();
const requireAdmin = [authMiddleware, requireRole("admin")];

// Public (pre-auth) routes
adminRouter.post("/signup", adminSignup);
adminRouter.post("/login", adminLogin);
// adminRouter.post("/logout/:id", adminLogout);
adminRouter.post("/logout", adminLogout);
adminRouter.post("/forgot-password", forgotPassword);
adminRouter.post("/verify-otp", verifyOTP);

// ✅ Step 3: Reset password
adminRouter.post("/reset-password", resetPassword);

// Protected (admin-only) routes
adminRouter.post("/change-password/:id", ...requireAdmin, adminChangePassword);
adminRouter.put("/updateAdmin/:id", ...requireAdmin, updateAdmin);
adminRouter.get("/totalusers", ...requireAdmin, totalUsers);
adminRouter.get("/groomsdetails", ...requireAdmin, groomsDetails);
adminRouter.get("/bridesdetails", ...requireAdmin, brideDetails);
adminRouter.get("/newregistrations", ...requireAdmin, newRegistrations);
adminRouter.get("/registrationstats", ...requireAdmin, userGrowth);
adminRouter.get("/getpendingusers", ...requireAdmin, getPendingUser);
adminRouter.patch("/approveuser/:id", ...requireAdmin, approveUser);
adminRouter.patch("/denyuser/:id", ...requireAdmin, denyUser);
adminRouter.get("/getdenyusers", ...requireAdmin, getDenyUser);
adminRouter.get("/getapproveusers", ...requireAdmin, getApproveUser);

adminRouter.get("/filter", ...requireAdmin, adminFilterUsers);
adminRouter.get("/filter-options", ...requireAdmin, adminFilterOptions);
// adminRouter.get("/:id", getUserById);

adminRouter.get("/getprofile/:id", ...requireAdmin, getProfileById);
adminRouter.delete("/deleteprofile/:id", ...requireAdmin, deleteProfileById);
adminRouter.get("/getadmininfo/:id", ...requireAdmin, getAdminInfo)
adminRouter.get("/getadmin/", ...requireAdmin, getadmin)
// adminRouter.put("/updateuserbyadmin/:id", adminupdateProfile);


// Update user profile by admin - with file uploads
adminRouter.put('/updateuserbyadmin/:id', ...requireAdmin, upload.fields([
  { name: 'aadhaarFrontphoto', maxCount: 1 },
  { name: 'aadhaarBackphoto', maxCount: 1 },
  { name: 'panFrontphoto', maxCount: 1 },
  { name: 'panBackphoto', maxCount: 1 },
  { name: 'passportFrontphoto', maxCount: 1 },
  { name: 'passportBackphoto', maxCount: 1 },
  { name: 'photoFulls', maxCount: 1 },
  { name: 'highestEducationalDoc', maxCount: 1 },
  { name: 'castecertificate', maxCount: 1 },
  { name: 'photoCloseup', maxCount: 1 },
  { name: 'photoFull', maxCount: 1 },
  { name: 'familyPhoto', maxCount: 1 }
]), adminuserProfileupdate);


adminRouter.post(
  "/bulk-upload",
  ...requireAdmin,
  upload.single("excel"), ExcelregisterUsers);

export default adminRouter;
