import Favorite from '../models/Favorite.js';
import Matrimony from '../models/Matrimony.js';
import AuthService from './AuthService.js';

class FavoriteService {
  async getFavorites(userId) {
    if (!userId) return [];
    const favorites = await Favorite.find({ userId, isFavorite: true }).lean();
    return favorites.map(f => f.profileId.toString());
  }

  async toggleFavorite(userId, profileId) {
    if (!userId || !profileId) {
      const error = new Error('Invalid user or profile ID');
      error.statusCode = 400;
      throw error;
    }

    let targetMatrimony = await Matrimony.findById(profileId);
    const targetId = targetMatrimony ? targetMatrimony._id : profileId;

    const existing = await Favorite.findOne({ userId, profileId: targetId });
    if (existing) {
      await Favorite.deleteOne({ _id: existing._id });
      const currentList = await this.getFavorites(userId);
      return { isFavorite: false, favorites: currentList };
    } else {
      await Favorite.create({ userId, profileId: targetId, isFavorite: true });
      const currentList = await this.getFavorites(userId);
      return { isFavorite: true, favorites: currentList };
    }
  }

  async getFavoriteProfiles(userId) {
    const favoriteIds = await this.getFavorites(userId);
    if (!favoriteIds || favoriteIds.length === 0) return [];

    const matrimonyDocs = await Matrimony.find({ _id: { $in: favoriteIds } });

    const profiles = [];
    for (const doc of matrimonyDocs) {
      const merged = await AuthService.getMergedUser(doc);
      profiles.push(merged);
    }
    return profiles;
  }
}

export default new FavoriteService();
