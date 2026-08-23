import SettingsService from '../services/SettingsService.js';
import { ApiResponse } from '../utils/apiResponse.js';

class SettingsController {
  async getSettings(req, res, next) {
    try {
      const settings = await SettingsService.getSettings(req.user._id);
      return ApiResponse.success(res, 'Settings retrieved', settings, 200);
    } catch (error) {
      next(error);
    }
  }

  async updatePrivacySettings(req, res, next) {
    try {
      const settings = await SettingsService.updatePrivacySettings(req.user._id, req.body);
      return ApiResponse.success(res, 'Privacy settings updated', settings, 200);
    } catch (error) {
      next(error);
    }
  }

  async updateNotificationPrefs(req, res, next) {
    try {
      const settings = await SettingsService.updateNotificationPrefs(req.user._id, req.body);
      return ApiResponse.success(res, 'Notification preferences updated', settings, 200);
    } catch (error) {
      next(error);
    }
  }

  async updateLanguage(req, res, next) {
    try {
      const { language } = req.body;
      const settings = await SettingsService.updateLanguage(req.user._id, language);
      return ApiResponse.success(res, 'Language preference updated', settings, 200);
    } catch (error) {
      next(error);
    }
  }
}

export default new SettingsController();
