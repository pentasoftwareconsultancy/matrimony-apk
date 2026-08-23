import AuthService from '../services/AuthService.js';
import { ApiResponse } from '../utils/apiResponse.js';

class AuthController {
  async login(req, res, next) {
    try {
      const data = await AuthService.loginUser(req.body);
      return ApiResponse.success(res, 'Login operation processed', data, 200);
    } catch (error) {
      next(error);
    }
  }

  async verifyOTP(req, res, next) {
    try {
      const data = await AuthService.verifyOTP(req.body);
      return ApiResponse.success(res, 'Verification successful', data, 200);
    } catch (error) {
      next(error);
    }
  }

  async register(req, res, next) {
    try {
      const userId = req.user ? req.user._id : null;
      const data = await AuthService.completeRegistration(userId, req.body);
      return ApiResponse.success(res, 'Registration completed successfully', data, 200);
    } catch (error) {
      next(error);
    }
  }

  async getCurrentUser(req, res, next) {
    try {
      const mergedUser = await AuthService.getMergedUser(req.user);
      return ApiResponse.success(res, 'User profile retrieved', { user: mergedUser }, 200);
    } catch (error) {
      next(error);
    }
  }

  async checkUser(req, res, next) {
    try {
      const data = await AuthService.checkUser(req.body);
      return ApiResponse.success(res, 'User check completed', data, 200);
    } catch (error) {
      next(error);
    }
  }

  async sendOTP(req, res, next) {
    try {
      const data = await AuthService.sendOTP(req.body);
      return ApiResponse.success(res, 'OTP sent successfully', data, 200);
    } catch (error) {
      next(error);
    }
  }

  async forgotPassword(req, res, next) {
    try {
      const data = await AuthService.forgotPassword(req.body);
      return ApiResponse.success(res, 'Password reset instructions sent', data, 200);
    } catch (error) {
      next(error);
    }
  }

  async verifyForgotOtp(req, res, next) {
    try {
      const data = await AuthService.verifyForgotOtp(req.body);
      return ApiResponse.success(res, 'OTP verified', data, 200);
    } catch (error) {
      next(error);
    }
  }

  async resetPassword(req, res, next) {
    try {
      const data = await AuthService.resetPassword(req.body);
      return ApiResponse.success(res, 'Password reset successful', data, 200);
    } catch (error) {
      next(error);
    }
  }

  async changePassword(req, res, next) {
    try {
      const data = await AuthService.changePassword(req.user._id, req.body);
      return ApiResponse.success(res, 'Password changed successfully', data, 200);
    } catch (error) {
      next(error);
    }
  }
}

export default new AuthController();
