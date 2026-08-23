import ProfileService from '../services/ProfileService.js';
import { ApiResponse } from '../utils/apiResponse.js';

class ProfileController {
  async getMyProfile(req, res, next) {
    try {
      const userId = req.user._id || req.user.id;
      const profileObj = await ProfileService.getProfileByUserId(userId);
      if (!profileObj) {
        return ApiResponse.error(res, 'Profile not found', 404);
      }

      return ApiResponse.success(res, 'Profile retrieved successfully', { profile: profileObj }, 200);
    } catch (error) {
      next(error);
    }
  }

  async updateMyProfile(req, res, next) {
    try {
      const userId = req.user._id || req.user.id;
      const profileObj = await ProfileService.updateProfile(userId, req.body);
      return ApiResponse.success(res, 'Profile updated successfully', { profile: profileObj }, 200);
    } catch (error) {
      next(error);
    }
  }

  async savePartnerPreference(req, res, next) {
    try {
      const userId = req.user._id || req.user.id;
      const profile = await ProfileService.savePartnerPreference(userId, req.body);
      return ApiResponse.success(res, 'Partner preferences saved successfully', { profile }, 200);
    } catch (error) {
      next(error);
    }
  }

  async getMatches(req, res, next) {
    try {
      const userId = req.user ? (req.user._id || req.user.id) : null;
      const matches = await ProfileService.getMatches(userId, req.query);
      return ApiResponse.success(res, 'Matches retrieved successfully', matches, 200);
    } catch (error) {
      next(error);
    }
  }

  async getProfileById(req, res, next) {
    try {
      const profile = await ProfileService.getProfileById(req.params.id);
      if (!profile) {
        return ApiResponse.error(res, 'Profile not found', 404);
      }
      return ApiResponse.success(res, 'Profile retrieved successfully', { profile }, 200);
    } catch (error) {
      next(error);
    }
  }

  async recordView(req, res, next) {
    try {
      const viewerUserId = req.user._id || req.user.id;
      const { id } = req.params;
      const result = await ProfileService.recordProfileView(viewerUserId, id);
      return ApiResponse.success(res, 'Profile view recorded', { view: result }, 200);
    } catch (error) {
      next(error);
    }
  }

  async getProfileViews(req, res, next) {
    try {
      const viewedUserId = req.user._id || req.user.id;
      const result = await ProfileService.getProfileViews(viewedUserId);
      return ApiResponse.success(res, 'Profile views retrieved', result, 200);
    } catch (error) {
      next(error);
    }
  }
}

export default new ProfileController();
