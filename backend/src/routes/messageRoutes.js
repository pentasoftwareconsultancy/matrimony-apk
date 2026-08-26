import express from 'express';
import MessageController from '../controllers/MessageController.js';
import { protect } from '../middlewares/authMiddleware.js';

const router = express.Router();

router.get('/conversations', protect, MessageController.getConversations);

router.get('/presence/:userId', protect, MessageController.getUserPresence);

router.get('/:partnerId', protect, MessageController.getMessagesWithPartner);

router.post('/:partnerId', protect, MessageController.sendMessage);

export default router;
