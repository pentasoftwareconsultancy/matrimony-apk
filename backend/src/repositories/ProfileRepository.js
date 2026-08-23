import Matrimony from '../models/Matrimony.js';

class ProfileRepository {
  async findByUserId(userId) {
    if (!userId) return null;
    return await Matrimony.findById(userId);
  }

  async create(profileData) {
    const matrimony = new Matrimony(profileData);
    return await matrimony.save();
  }

  async updateByUserId(userId, updateData) {
    return await Matrimony.findByIdAndUpdate(userId, { $set: updateData }, {
      new: true,
      upsert: false,
      runValidators: false,
    });
  }

  async deleteByUserId(userId) {
    return await Matrimony.findByIdAndDelete(userId);
  }
}

export default new ProfileRepository();
