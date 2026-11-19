import NotificationService from '../services/NotificationService.js';
import { ApiResponse } from '../utils/apiResponse.js';

class NotificationController {
  async getNotifications(req, res, next) {
    try {
      const isMr = req.language === 'mr';
      const notifications = await NotificationService.getNotifications(req.user._id, req.language);
      return ApiResponse.success(res, isMr ? 'सूचना प्राप्त झाल्या' : 'Notifications retrieved', notifications, 200);
    } catch (error) {
      next(error);
    }
  }

  async markAsRead(req, res, next) {
    try {
      const isMr = req.language === 'mr';
      const { id } = req.params;
      const notifications = await NotificationService.markAsRead(req.user._id, id);
      return ApiResponse.success(res, isMr ? 'सूचना वाचली म्हणून चिन्हांकित केली' : 'Notification marked as read', notifications, 200);
    } catch (error) {
      next(error);
    }
  }

  async clearAllUnread(req, res, next) {
    try {
      const isMr = req.language === 'mr';
      const notifications = await NotificationService.clearAllUnread(req.user._id);
      return ApiResponse.success(res, isMr ? 'सर्व सूचना वाचल्या म्हणून चिन्हांकित केल्या' : 'All notifications marked as read', notifications, 200);
    } catch (error) {
      next(error);
    }
  }

    async deleteNotification(req, res, next) {
      try {
        const isMr = req.language === 'mr';
        const { id } = req.params;

        const notifications =
            await NotificationService.deleteNotification(
          req.user._id,
          id,
        );

        return ApiResponse.success(
          res,
          isMr ? 'सूचना हटवली' : 'Notification deleted',
          notifications,
          200,
        );
      } catch (error) {
        next(error);
      }
    }
}

export default new NotificationController();
