import BlockedUser from '../models/BlockedUser.js';

class BlockedService {
  async getBlockedUsers(userId) {
    const records = await BlockedUser.find({ userId }).lean();
    return records.map(r => r.blockedUserId);
  }

  async blockUser(userId, blockedUserId) {
    const existing = await BlockedUser.findOne({ userId, blockedUserId });
    if (!existing) {
      await BlockedUser.create({ userId, blockedUserId });
    }
    return await this.getBlockedUsers(userId);
  }

  async unblockUser(userId, blockedUserId) {
    await BlockedUser.deleteOne({ userId, blockedUserId });
    return await this.getBlockedUsers(userId);
  }
}

export default new BlockedService();
