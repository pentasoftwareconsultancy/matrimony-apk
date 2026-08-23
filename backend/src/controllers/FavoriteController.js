import FavoriteService from '../services/FavoriteService.js';
import { ApiResponse } from '../utils/apiResponse.js';

class FavoriteController {
  async getFavorites(req, res, next) {
    try {
      const favorites = await FavoriteService.getFavorites(req.user._id);
      return ApiResponse.success(res, 'Favorites retrieved successfully', favorites, 200);
    } catch (error) {
      next(error);
    }
  }

  async toggleFavorite(req, res, next) {
    try {
      const { profileId } = req.params;
      const result = await FavoriteService.toggleFavorite(req.user._id, profileId);
      return ApiResponse.success(res, 'Favorite state toggled', result, 200);
    } catch (error) {
      next(error);
    }
  }

  async getFavoriteProfiles(req, res, next) {
    try {
      const profiles = await FavoriteService.getFavoriteProfiles(req.user._id);
      return ApiResponse.success(res, 'Favorite profiles retrieved', profiles, 200);
    } catch (error) {
      next(error);
    }
  }
}

export default new FavoriteController();
