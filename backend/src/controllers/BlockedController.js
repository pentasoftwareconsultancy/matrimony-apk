import BlockedService from '../services/BlockedService.js';
import { ApiResponse } from '../utils/apiResponse.js';

class BlockedController {
  async getBlockedUsers(req, res, next) {
    try {
      const blocked = await BlockedService.getBlockedUsers(req.user._id);
      return ApiResponse.success(res, 'Blocked profiles retrieved', blocked, 200);
    } catch (error) {
      next(error);
    }
  }

  async blockUser(req, res, next) {
    try {
      const { profileId } = req.params;
      const blocked = await BlockedService.blockUser(req.user._id, profileId);
      return ApiResponse.success(res, 'User blocked successfully', blocked, 200);
    } catch (error) {
      next(error);
    }
  }

  async unblockUser(req, res, next) {
    try {
      const { profileId } = req.params;
      const blocked = await BlockedService.unblockUser(req.user._id, profileId);
      return ApiResponse.success(res, 'User unblocked successfully', blocked, 200);
    } catch (error) {
      next(error);
    }
  }
}

export default new BlockedController();
