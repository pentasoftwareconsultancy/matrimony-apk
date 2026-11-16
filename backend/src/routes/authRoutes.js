import express from 'express';
import AuthController from '../controllers/AuthController.js';
import UploadController from '../controllers/UploadController.js';
import { protect, optionalProtect } from '../middlewares/authMiddleware.js';
import {
  createUploadFields,
  createUploadRateLimiter,
} from '../middlewares/uploadMiddleware.js';
import {
  validate,
  loginSchema,
  verifyOtpSchema,
  registerSchema,
  checkUserSchema,
  sendOtpSchema,
  forgotPasswordSchema,
  resetPasswordSchema,
  changePasswordSchema,
} from '../middlewares/validationMiddleware.js';

const router = express.Router();
const uploadRateLimiter = createUploadRateLimiter({ maxRequests: 20 });
const upload = createUploadFields(
  [
    { name: 'aadharCard', maxCount: 1 },
    { name: 'casteCertificate', maxCount: 1 },
    { name: 'photos', maxCount: 6 },
  ],
  { pdfFields: ['aadharCard', 'casteCertificate'] }
);

router.post('/login', validate(loginSchema), AuthController.login);
router.post('/check-user', validate(checkUserSchema), AuthController.checkUser);
router.post('/send-otp', validate(sendOtpSchema), AuthController.sendOTP);
router.post('/verify-otp', validate(verifyOtpSchema), AuthController.verifyOTP);
router.post('/register', optionalProtect, validate(registerSchema), AuthController.register);
router.post('/forgot-password', validate(forgotPasswordSchema), AuthController.forgotPassword);
router.post('/verify-forgot-otp', AuthController.verifyForgotOtp);
router.post('/reset-password', validate(resetPasswordSchema), AuthController.resetPassword);
router.post('/change-password', protect, validate(changePasswordSchema), AuthController.changePassword);
router.post('/upload', uploadRateLimiter, upload, UploadController.uploadFiles);
router.get('/me', protect, AuthController.getCurrentUser);

export default router;
