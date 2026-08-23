import express from 'express';
import SettingsController from '../controllers/SettingsController.js';
import { protect } from '../middlewares/authMiddleware.js';

const router = express.Router();

router.get('/', protect, SettingsController.getSettings);
router.put('/privacy', protect, SettingsController.updatePrivacySettings);
router.put('/notifications', protect, SettingsController.updateNotificationPrefs);
router.put('/language', protect, SettingsController.updateLanguage);

export default router;
