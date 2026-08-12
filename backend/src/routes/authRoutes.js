import express from 'express';
import multer from 'multer';
import AuthController from '../controllers/AuthController.js';
import UploadController from '../controllers/UploadController.js';
import { protect, optionalProtect } from '../middlewares/authMiddleware.js';
import {
  validate,
  loginSchema,
  verifyOtpSchema,
  registerSchema,
  checkUserSchema,
  sendOtpSchema,
} from '../middlewares/validationMiddleware.js';

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() }).fields([
  { name: 'aadharCard', maxCount: 1 },
  { name: 'photos', maxCount: 6 }
]);

router.post('/login', validate(loginSchema), AuthController.login);
router.post('/check-user', validate(checkUserSchema), AuthController.checkUser);
router.post('/send-otp', validate(sendOtpSchema), AuthController.sendOTP);
router.post('/verify-otp', validate(verifyOtpSchema), AuthController.verifyOTP);
router.post('/register', optionalProtect, validate(registerSchema), AuthController.register);
router.post('/upload', upload, UploadController.uploadFiles);
router.get('/me', protect, AuthController.getCurrentUser);

export default router;
