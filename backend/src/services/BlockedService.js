import mongoose from 'mongoose';
import BlockedUser from '../models/BlockedUser.js';
import Matrimony from '../models/Matrimony.js';
import AuthService from './AuthService.js';

function assertValidTargetId(userId, targetId, actionLabel) {
  if (!targetId || !mongoose.Types.ObjectId.isValid(targetId)) {
    const error = new Error('Invalid target user ID');
    error.statusCode = 400;
    throw error;
  }
  if (userId && userId.toString() === targetId.toString()) {
    const error = new Error(`You cannot ${actionLabel} yourself`);
    error.statusCode = 400;
    throw error;
  }
}

class BlockedService {
  async getBlockedUsers(userId) {
    const records = await BlockedUser.find({
      fromUser: userId,
      actionType: 'ignore',
      active: true,
    })
      .select('toUser')
      .lean();
    return records.map((r) => r.toUser.toString());
  }

  async getBlockedProfiles(userId) {
    const blockedIds = await this.getBlockedUsers(userId);
    if (blockedIds.length === 0) return [];

    const docs = await Matrimony.find({ _id: { $in: blockedIds } }).lean();
    return await Promise.all(
      docs.map((doc) => AuthService.getMergedUser(doc, { includePrivate: false }))
    );
  }

  async blockUser(userId, blockedUserId) {
    assertValidTargetId(userId, blockedUserId, 'block');

    const targetExists = await Matrimony.exists({ _id: blockedUserId });
    if (!targetExists) {
      const error = new Error('Target profile not found');
      error.statusCode = 404;
      throw error;
    }

    await BlockedUser.findOneAndUpdate(
      { fromUser: userId, toUser: blockedUserId, actionType: 'ignore' },
      { $set: { active: true } },
      { upsert: true, new: true }
    );

    return await this.getBlockedUsers(userId);
  }

  async unblockUser(userId, blockedUserId) {
    assertValidTargetId(userId, blockedUserId, 'unblock');

    await BlockedUser.deleteOne({
      fromUser: userId,
      toUser: blockedUserId,
      actionType: 'ignore',
    });

    return await this.getBlockedUsers(userId);
  }
}

export default new BlockedService();
