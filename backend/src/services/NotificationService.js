import Notification from '../models/Notification.js';

class NotificationService {
  async getNotifications(userId) {
    if (!userId) return [];

    const notifications = await Notification.find({
      $or: [{ user: userId }, { userId }]
    })
      .sort({ createdAt: -1 })
      .lean();

    return notifications.map(n => ({
      id: n._id.toString(),
      profileId: n.profileId || n.user?.toString() || '',
      profileImage: n.senderImage || n.profileImage || 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      title: n.title || 'Notification',
      subtitle: n.message || n.subtitle || '',
      time: n.createdAt ? new Date(n.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : 'Just now',
      type: n.type || 'interest',
      isRead: n.isRead || false,
    }));
  }

  async markAsRead(userId, notificationId) {
    await Notification.updateOne(
      { _id: notificationId, $or: [{ user: userId }, { userId }] },
      { isRead: true }
    );
    return await this.getNotifications(userId);
  }

  async clearAllUnread(userId) {
    await Notification.updateMany(
      { $or: [{ user: userId }, { userId }], isRead: false },
      { isRead: true }
    );
    return await this.getNotifications(userId);
  }
}

export default new NotificationService();
