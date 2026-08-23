import express from 'express';
import FavoriteController from '../controllers/FavoriteController.js';
import { protect } from '../middlewares/authMiddleware.js';

const router = express.Router();

router.get('/', protect, FavoriteController.getFavorites);
router.get('/profiles', protect, FavoriteController.getFavoriteProfiles);
router.post('/:profileId/toggle', protect, FavoriteController.toggleFavorite);

export default router;
