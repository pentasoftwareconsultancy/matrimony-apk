import NotificationService from '../services/NotificationService.js';
import { ApiResponse } from '../utils/apiResponse.js';

class NotificationController {
  async getNotifications(req, res, next) {
    try {
      const notifications = await NotificationService.getNotifications(req.user._id);
      return ApiResponse.success(res, 'Notifications retrieved', notifications, 200);
    } catch (error) {
      next(error);
    }
  }

  async markAsRead(req, res, next) {
    try {
      const { id } = req.params;
      const notifications = await NotificationService.markAsRead(req.user._id, id);
      return ApiResponse.success(res, 'Notification marked as read', notifications, 200);
    } catch (error) {
      next(error);
    }
  }

  async clearAllUnread(req, res, next) {
    try {
      const notifications = await NotificationService.clearAllUnread(req.user._id);
      return ApiResponse.success(res, 'All notifications marked as read', notifications, 200);
    } catch (error) {
      next(error);
    }
  }

    async deleteNotification(req, res, next) {
      try {
        const { id } = req.params;

        const notifications =
            await NotificationService.deleteNotification(
          req.user._id,
          id,
        );

        return ApiResponse.success(
          res,
          'Notification deleted',
          notifications,
          200,
        );
      } catch (error) {
        next(error);
      }
    }
}

export default new NotificationController();
