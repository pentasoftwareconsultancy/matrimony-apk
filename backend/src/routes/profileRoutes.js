import express from 'express';
import ProfileController from '../controllers/ProfileController.js';
import { protect } from '../middlewares/authMiddleware.js';
import { createUploadFields } from '../middlewares/uploadMiddleware.js';

const router = express.Router();
const uploadPhotoFields = createUploadFields([
  { name: 'photo', maxCount: 1 },
  { name: 'photos', maxCount: 1 },
]);
const uploadDocumentFields = createUploadFields(
  [
    { name: 'document', maxCount: 1 },
    { name: 'file', maxCount: 1 },
  ],
  { pdfFields: ['document', 'file'] }
);

router.get('/me', protect, ProfileController.getMyProfile);
router.put('/me', protect, ProfileController.updateMyProfile);
router.post('/photos', protect, uploadPhotoFields, ProfileController.uploadPhoto);
router.delete('/photos', protect, ProfileController.deletePhoto);
router.post('/documents', protect, uploadDocumentFields, ProfileController.uploadDocument);
router.delete('/documents/:docId', protect, ProfileController.deleteDocument);
router.post('/partner-preference', protect, ProfileController.savePartnerPreference);
router.get('/matches', protect, ProfileController.getMatches);
router.get('/views', protect, ProfileController.getProfileViews);
router.post('/views/:id', protect, ProfileController.recordView);
router.get('/:id', protect, ProfileController.getProfileById);

export default router;
