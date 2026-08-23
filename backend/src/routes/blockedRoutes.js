import express from 'express';
import BlockedController from '../controllers/BlockedController.js';
import { protect } from '../middlewares/authMiddleware.js';

const router = express.Router();

router.get('/', protect, BlockedController.getBlockedUsers);
router.post('/:profileId', protect, BlockedController.blockUser);
router.delete('/:profileId', protect, BlockedController.unblockUser);

export default router;
