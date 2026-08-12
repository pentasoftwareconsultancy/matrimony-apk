import Profile from '../models/Profile.js';

class ProfileRepository {
  async findByUserId(userId) {
    return await Profile.findOne({ userId });
  }

  async create(profileData) {
    const profile = new Profile(profileData);
    return await profile.save();
  }

  async updateByUserId(userId, updateData) {
    return await Profile.findOneAndUpdate({ userId }, updateData, {
      new: true,
      upsert: true,
      runValidators: true,
    });
  }

  async deleteByUserId(userId) {
    return await Profile.findOneAndDelete({ userId });
  }
}

export default new ProfileRepository();
