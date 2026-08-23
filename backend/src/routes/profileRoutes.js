import express from 'express';
import ProfileController from '../controllers/ProfileController.js';
import { protect, optionalProtect } from '../middlewares/authMiddleware.js';

const router = express.Router();

router.get('/me', protect, ProfileController.getMyProfile);
router.put('/me', protect, ProfileController.updateMyProfile);
router.post('/partner-preference', protect, ProfileController.savePartnerPreference);
router.get('/matches', optionalProtect, ProfileController.getMatches);
router.get('/views', protect, ProfileController.getProfileViews);
router.post('/views/:id', protect, ProfileController.recordView);
router.get('/:id', optionalProtect, ProfileController.getProfileById);

export default router;
