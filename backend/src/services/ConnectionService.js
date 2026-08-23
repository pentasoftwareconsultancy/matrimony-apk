import UserAction from '../models/UserAction.js';
import Notification from '../models/Notification.js';
import Matrimony from '../models/Matrimony.js';
import AuthService from './AuthService.js';

class ConnectionService {
  async getConnections(userId) {
    if (!userId) return [];
    const actions = await UserAction.find({
      $or: [{ fromUser: userId }, { toUser: userId }]
    }).lean();

    return actions;
  }

  async expressInterest(fromUserId, toUserId) {
    if (fromUserId.toString() === toUserId.toString()) {
      const error = new Error('You cannot express interest in your own profile.');
      error.statusCode = 400;
      throw error;
    }

    let existing = await UserAction.findOne({
      fromUser: fromUserId,
      toUser: toUserId,
      actionType: 'interest'
    });

    if (existing) {
      return { success: true, message: 'Interest request already sent or connected', connection: existing };
    }

    const action = await UserAction.create({
      fromUser: fromUserId,
      toUser: toUserId,
      actionType: 'interest',
      active: true,
    });

    const senderMatrimony = await Matrimony.findById(fromUserId);
    const senderMerged = senderMatrimony ? await AuthService.getMergedUser(senderMatrimony) : null;
    const senderName = senderMerged ? senderMerged.fullName : 'A member';
    const senderImage = (senderMerged && senderMerged.photos && senderMerged.photos.length > 0)
      ? senderMerged.photos[0]
      : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100';

    await Notification.create({
      user: toUserId,
      type: 'interest',
      message: `${senderName} expressed interest in your profile.`,
      senderImage,
      isRead: false,
    });

    return { success: true, message: 'Interest expressed successfully', connection: action };
  }

  async respondToInterest(userId, connectionId, status) {
    const action = await UserAction.findById(connectionId);
    if (!action) {
      const error = new Error('Interest request not found');
      error.statusCode = 404;
      throw error;
    }

    if (action.toUser.toString() !== userId.toString()) {
      const error = new Error('Unauthorized to respond to this request');
      error.statusCode = 403;
      throw error;
    }

    action.active = status === 'accepted';
    await action.save();

    const responderMatrimony = await Matrimony.findById(userId);
    const responderMerged = responderMatrimony ? await AuthService.getMergedUser(responderMatrimony) : null;
    const responderName = responderMerged ? responderMerged.fullName : 'A member';

    await Notification.create({
      user: action.fromUser,
      type: 'interest',
      message: `${responderName} ${status === 'accepted' ? 'accepted' : 'declined'} your interest request.`,
      senderImage: responderMerged?.photos?.[0],
      isRead: false,
    });

    return { success: true, message: `Interest ${status}`, connection: action };
  }
}

export default new ConnectionService();
