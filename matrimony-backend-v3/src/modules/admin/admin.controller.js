// src/controllers/AdminController.js
import {
  AppError,
  cookieOption,
  flattenValidationErrors,
  signupAdmin,
  loginAdmin,
  updateAdminById,
  requestAdminPasswordResetOtp,
  verifyAdminOtp,
  resetAdminPassword,
  updateUserProfileByAdmin,
  changeAdminPassword,
} from "./admin.service.js";

export const adminSignup = async (req, res) => {
  try {
    const { token, admin } = await signupAdmin(req.body);

    res.cookie("token", token, cookieOption);

    res.status(200).json({
      success: true,
      message: "Admin registered successfully",
      admin,
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res
        .status(error.status)
        .json({ success: false, message: error.message, ...error.extra });
    }
    console.error(
      `❌ Admin signup error at ${new Date().toISOString()}:`,
      error
    );
    return res.status(500).json({ success: false, message: error.message });
  }
};

export const adminLogin = async (req, res) => {
  try {
    const { email, password } = req.body;
    const { token, admin } = await loginAdmin(email, password);

    res.cookie("token", token, cookieOption);

    res.status(200).json({
      success: true,
      message: "Admin login successful",
      admin,
      token,
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res
        .status(error.status)
        .json({ success: false, message: error.message, ...error.extra });
    }
    console.error(
      `❌ Admin login error at ${new Date().toISOString()}:`,
      error
    );
    return res.status(500).json({ success: false, message: error.message });
  }
};

export const adminLogout = (req, res) => {
  try {
    res.clearCookie("token", {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "strict",
    });
    return res.status(200).json({
      success: true,
      message: "Logout successful",
    });
  } catch (error) {
    console.error(
      `❌ Admin logout error at ${new Date().toISOString()}:`,
      error
    );
    return res.status(500).json({ success: false, message: error.message });
  }
};

export const updateAdmin = async (req, res) => {
  try {
    const { id } = req.params;
    const { updatedAdmin, token } = await updateAdminById(id, req.body);

    if (token) {
      res.cookie("token", token, cookieOption);
    }

    return res.status(200).json({
      success: true,
      message: "Admin updated successfully",
      admin: updatedAdmin,
    });
  } catch (error) {
    console.error(
      `❌ Update admin error at ${new Date().toISOString()}:`,
      error
    );

    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    if (error.name === "ValidationError") {
      const messages = Object.values(error.errors).map((err) => err.message);
      return res.status(400).json({ success: false, message: messages.join(", ") });
    }
    if (error.code === 11000) {
      return res.status(400).json({ success: false, message: "Email already exists" });
    }
    return res.status(500).json({ success: false, message: "Internal server error" });
  }
};

export const forgotPassword = async (req, res) => {
  const { email } = req.body;
  try {
    const result = await requestAdminPasswordResetOtp(email);

    if (result.status === "no-admin") {
      return res.status(200).json({
        success: true,
        message: "If the email is registered, an OTP will be sent",
      });
    }

    if (result.status === "sent") {
      return res.status(200).json({
        success: true,
        message: "OTP sent to your email successfully",
      });
    }

    // result.status === "dev-fallback"
    return res.status(200).json({
      success: true,
      message:
        "OTP generated successfully. Email service unavailable, check server logs for OTP.",
      note: "Email service is currently unavailable. Check server logs for OTP in development mode.",
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res
        .status(error.status)
        .json({ success: false, message: error.message, ...error.extra });
    }
    console.error(
      `❌ Forgot password error for ${email} at ${new Date().toISOString()}:`,
      error
    );
    return res.status(500).json({
      success: false,
      message: "Failed to process request",
      error: error.message,
    });
  }
};

export const verifyOTP = async (req, res) => {
  const { email, otp } = req.body;
  try {
    verifyAdminOtp(email, otp);

    return res.status(200).json({
      success: true,
      message: "OTP verified successfully",
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    console.error(
      `❌ Verify OTP error for ${email} at ${new Date().toISOString()}:`,
      error
    );
    return res.status(500).json({
      success: false,
      message: "Server error during OTP verification",
      error: error.message,
    });
  }
};

export const resetPassword = async (req, res) => {
  const { email, otp, newPassword } = req.body;
  try {
    await resetAdminPassword(email, otp, newPassword);

    return res.status(200).json({
      success: true,
      message: "Password reset successfully",
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    console.error(
      `❌ Reset password error for ${email} at ${new Date().toISOString()}:`,
      error
    );
    return res.status(500).json({
      success: false,
      message: "Server error during password reset",
      error: error.message,
    });
  }
};

// UPDATE USER PROFILE BY ADMIN CONTROLLER
export const adminuserProfileupdate = async (req, res) => {
  try {
    const userId = req.params.id;
    const userResponse = await updateUserProfileByAdmin(userId, req.body, req.files);

    res.status(200).json({
      success: true,
      message: "Profile updated successfully",
      user: userResponse,
    });
  } catch (error) {
    console.error("Update error:", error);

    if (error instanceof AppError) {
      return res
        .status(error.status)
        .json({ success: false, message: error.message, ...error.extra });
    }
    if (error.name === "ValidationError") {
      return res.status(400).json({
        success: false,
        message: "Validation failed",
        errors: flattenValidationErrors(error),
      });
    }
    if (error.name === "CastError") {
      return res.status(400).json({
        success: false,
        message: `Invalid data format for field: ${error.path}`,
        error: `Expected ${error.kind}, received ${typeof error.value}`,
      });
    }
    res.status(500).json({
      success: false,
      message: "Server error during update",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

export const adminChangePassword = async (req, res) => {
  try {
    const adminId = req.params.id;
    await changeAdminPassword(adminId, req.body);

    res.status(200).json({
      success: true,
      message: "Password changed successfully",
    });
  } catch (error) {
    console.error(`❌ Admin change password error:`, error);
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    return res.status(500).json({ success: false, message: "Internal server error" });
  }
};