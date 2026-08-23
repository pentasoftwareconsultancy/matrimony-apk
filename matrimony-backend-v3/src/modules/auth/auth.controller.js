import {
  AppError,
  cookieOption,
  flattenValidationErrors,
  registerUser,
  updateUserProfile,
  authenticateUser,
  authenticateAny,
  requestPasswordResetOtp,
  verifyPasswordResetOtp,
  resetUserPassword,
} from "./auth.service.js";

// Sends a consistent error response for AppErrors vs unexpected errors.
const handleError = (res, error, fallbackMessage) => {
  if (error instanceof AppError) {
    return res.status(error.statusCode).json({
      success: false,
      message: error.message,
      ...error.extra,
    });
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

  console.error(fallbackMessage, error);
  return res.status(500).json({
    success: false,
    message: fallbackMessage,
    error: process.env.NODE_ENV === "development" ? error.message : undefined,
  });
};

// REGISTER CONTROLLER
export const userRegister = async (req, res) => {
  try {
    console.log("Request body:", JSON.stringify(req.body, null, 2));
    console.log("Request files:", JSON.stringify(req.files, null, 2));

    const { token, user } = await registerUser(req.body, req.files);

    res.cookie("matrimonyToken", token, cookieOption);

    res.status(201).json({
      success: true,
      message: "User registered successfully with caste certificate",
      token,
      user,
    });
  } catch (error) {
    handleError(res, error, "Server error during registration");
  }
};

// UPDATE PROFILE CONTROLLER (no password updates)
export const updateProfile = async (req, res) => {
  try {
    const userId = req.params.id || req.user?.id || req.body.userId;

    const updatedUser = await updateUserProfile(userId, req.body, req.files);

    res.status(200).json({
      success: true,
      message: "Profile updated successfully",
      user: updatedUser,
    });
  } catch (error) {
    handleError(res, error, "Server error during update");
  }
};

export const loginBrideGroom = async (req, res) => {
  try {
    const { email, password } = req.body;

    const { token, user } = await authenticateUser(email, password);

    res.cookie("matrimonyToken", token, cookieOption);

    res.status(200).json({
      success: true,
      message: "Login successful",
      token,
      user,
    });
  } catch (error) {
    handleError(res, error, "Server error during login");
  }
};

// Unified login for both admin and regular users — see authenticateAny().
export const loginAny = async (req, res) => {
  try {
    const { email, password } = req.body;

    const { token, user } = await authenticateAny(email, password);

    res.cookie("matrimonyToken", token, cookieOption);

    res.status(200).json({
      success: true,
      message: "Login successful",
      token,
      user,
    });
  } catch (error) {
    handleError(res, error, "Server error during login");
  }
};

export const logoutBrideGroom = async (req, res) => {
  try {
    res.clearCookie("matrimonyToken", {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: process.env.NODE_ENV === "production" ? "none" : "strict",
      path: "/", // Ensure path matches cookie
    });

    return res.status(200).json({
      success: true,
      message: "Logout successful",
      data: null,
    });
  } catch (error) {
    handleError(res, error, "Server error during logout");
  }
};

// Forgot Password
export const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    // Always return success to prevent email enumeration, whether or not
    // the email actually exists / an OTP was actually sent.
    await requestPasswordResetOtp(email);

    return res.status(200).json({
      success: true,
      message: "If the email is registered, an OTP will be sent",
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res
        .status(error.statusCode)
        .json({ success: false, message: error.message });
    }
    console.error("Forgot password error:", error.stack);
    return res.status(500).json({
      success: false,
      message: "Failed to process password reset request",
    });
  }
};

// Verify OTP
export const verifyOTP = async (req, res) => {
  try {
    const { email, otp } = req.body;

    verifyPasswordResetOtp(email, otp);

    return res.status(200).json({
      success: true,
      message: "OTP verified successfully",
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res
        .status(error.statusCode)
        .json({ success: false, message: error.message });
    }
    console.error("Verify OTP error:", error.stack);
    return res.status(500).json({
      success: false,
      message: "Server error during OTP verification",
    });
  }
};

// Reset Password
export const resetPassword = async (req, res) => {
  try {
    const { email, otp, newPassword, confirmPassword } = req.body;

    await resetUserPassword(email, otp, newPassword, confirmPassword);

    return res.status(200).json({
      success: true,
      message: "Password reset successful",
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res
        .status(error.statusCode)
        .json({ success: false, message: error.message });
    }
    console.error("Reset password error:", error.stack);
    return res.status(500).json({
      success: false,
      message: "Server error during password reset",
    });
  }
};