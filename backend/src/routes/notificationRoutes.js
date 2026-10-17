import express from 'express';
import NotificationController from '../controllers/NotificationController.js';
import { protect } from '../middlewares/authMiddleware.js';

const router = express.Router();

router.get('/', protect, NotificationController.getNotifications);

router.put(
  '/read-all',
  protect,
  NotificationController.clearAllUnread
);

router.put(
  '/:id/read',
  protect,
  NotificationController.markAsRead
);

// DELETE ONE NOTIFICATION
router.delete(
  '/:id',
  protect,
  NotificationController.deleteNotification
);

export default router;