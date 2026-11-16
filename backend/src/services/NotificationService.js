import Notification from '../models/Notification.js';
import Matrimony from '../models/Matrimony.js';

class NotificationService {
  // ============================================================
  // GET NOTIFICATIONS
  // ============================================================

  async getNotifications(userId) {
    if (!userId) {
      return [];
    }

    const notifications = await Notification.find({
      user: userId,
    })
      .sort({ createdAt: -1 })
      .lean();

    return notifications.map((notification) => ({
      id: notification._id.toString(),

      profileId: notification.profileId
        ? notification.profileId.toString()
        : '',

      profileImage:
        notification.senderImage ||
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',

      title:
        notification.title || 'Notification',

      subtitle:
        notification.message || '',

      time: notification.createdAt
        ? new Date(notification.createdAt).toLocaleTimeString([], {
            hour: '2-digit',
            minute: '2-digit',
          })
        : 'Just now',

      type:
        notification.type || 'profileActivity',

      isRead:
        notification.isRead === true,
    }));
  }

  // ============================================================
  // MARK ONE NOTIFICATION AS READ
  // ============================================================

  async markAsRead(userId, notificationId) {
    const notification = await Notification.findOne({
      _id: notificationId,
      user: userId,
    });

    if (!notification) {
      const error = new Error('Notification not found');
      error.statusCode = 404;
      throw error;
    }

    notification.isRead = true;

    await notification.save();

    return await this.getNotifications(userId);
  }



    // ============================================================
    // DELETE ONE NOTIFICATION
    // ============================================================

    async deleteNotification(userId, notificationId) {
      const notification = await Notification.findOne({
        _id: notificationId,
        user: userId,
      });

      if (!notification) {
        const error = new Error('Notification not found');
        error.statusCode = 404;
        throw error;
      }

      await Notification.deleteOne({
        _id: notificationId,
        user: userId,
      });

      return await this.getNotifications(userId);
    }

  // ============================================================
  // MARK ALL UNREAD AS READ
  // ============================================================

  async clearAllUnread(userId) {
    await Notification.updateMany(
      {
        user: userId,
        isRead: false,
      },
      {
        $set: {
          isRead: true,
        },
      }
    );

    return await this.getNotifications(userId);
  }

  // ============================================================
  // CREATE PROFILE VIEW NOTIFICATION
  // ============================================================

  async createProfileViewNotification({
    recipientUserId,
    actorUserId,
    profileId,
    senderImage,
  }) {
    if (!recipientUserId || !actorUserId || !profileId) {
      throw new Error(
        'Recipient, actor, and profile are required for profile view notification'
      );
    }

    const recipientId =
      recipientUserId.toString();

    const actorId =
      actorUserId.toString();

    const profileIdString =
      profileId.toString();

    // ==========================================================
    // NEVER NOTIFY USER ABOUT THEIR OWN PROFILE VIEW
    // ==========================================================

    if (recipientId === actorId) {
      return null;
    }

    // ==========================================================
    // DUPLICATE NOTIFICATION PROTECTION
    //
    // Only one profile-view notification for the same viewer
    // and recipient within 24 hours.
    // ==========================================================

    const twentyFourHoursAgo = new Date(
      Date.now() - 24 * 60 * 60 * 1000
    );

    const existingNotification =
      await Notification.findOne({
        user: recipientUserId,

        actorUserId: actorUserId,

        profileId: profileId,

        type: 'profileActivity',

        createdAt: {
          $gte: twentyFourHoursAgo,
        },
      })
        .select('_id')
        .lean();

    if (existingNotification) {
      return existingNotification;
    }

    // ==========================================================
    // GET THE ACTUAL VIEWER PROFILE
    //
    // Your Matrimony document stores:
    //
    // userRegistration.fullName
    // documentDetails.photos
    //
    // NOT:
    //
    // photos
    // ==========================================================

    const actorProfile =
      await Matrimony.findById(actorUserId)
        .select(
          'userRegistration.fullName documentDetails.photos'
        )
        .lean();

    // ==========================================================
    // ACTUAL VIEWER NAME
    // ==========================================================

    const actorName =
      actorProfile?.userRegistration?.fullName
        ?.trim() || 'Someone';

    // ==========================================================
    // ACTUAL VIEWER IMAGE
    // ==========================================================

    const actorPhotos =
      actorProfile?.documentDetails?.photos || [];

    let actorImage = '';

    if (
      Array.isArray(actorPhotos) &&
      actorPhotos.length > 0
    ) {
      // Find the first usable image
      actorImage =
        actorPhotos.find(
          (photo) =>
            typeof photo === 'string' &&
            photo.trim().length > 0
        ) || '';
    }

    // If the profile doesn't contain a usable image,
    // use the image passed from ProfileService.
    if (!actorImage && senderImage) {
      actorImage = senderImage;
    }

    // ==========================================================
    // DEBUG LOGGING
    // ==========================================================

    console.log(
      '[NotificationService] Creating profile view notification'
    );

    console.log(
      '[NotificationService] Recipient:',
      recipientId
    );

    console.log(
      '[NotificationService] Actor:',
      actorId
    );

    console.log(
      '[NotificationService] Profile:',
      profileIdString
    );

    console.log(
      '[NotificationService] Actor name:',
      actorName
    );

    console.log(
      '[NotificationService] Actor image:',
      actorImage || '(none)'
    );

    // ==========================================================
    // CREATE NOTIFICATION
    // ==========================================================

    const notification =
      await Notification.create({
        user: recipientUserId,

        // Actual person who viewed the profile
        actorUserId: actorUserId,

        // Profile that should open when notification
        // is tapped
        profileId: profileId,

        type: 'profileActivity',

        title: 'Profile viewed',

        message:
          `${actorName} viewed your profile`,

        senderImage:
          actorImage,

        isRead: false,
      });

    return notification;
  }
}

export default new NotificationService();