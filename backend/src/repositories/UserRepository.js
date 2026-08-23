import Matrimony from '../models/Matrimony.js';

class UserRepository {
  async findByEmail(email) {
    if (!email) return null;
    const cleanEmail = email.toString().trim().toLowerCase();
    return await Matrimony.findOne({
      "userRegistration.email": { $regex: new RegExp(`^${cleanEmail}$`, "i") }
    });
  }

  async findByPhone(phone) {
    if (!phone) return null;
    const numericPhone = Number(phone.toString().replace(/\D/g, ''));
    return await Matrimony.findOne({
      $or: [
        { "userRegistration.phoneNumber": numericPhone },
        { "userRegistration.phoneNumber": phone.toString().trim() }
      ]
    });
  }

  async findById(id) {
    if (!id) return null;
    return await Matrimony.findById(id);
  }

  async create(userData) {
    const matrimony = new Matrimony(userData);
    return await matrimony.save();
  }

  async update(id, updateData) {
    return await Matrimony.findByIdAndUpdate(id, updateData, {
      new: true,
      runValidators: false,
    });
  }

  async delete(id) {
    return await Matrimony.findByIdAndDelete(id);
  }

  async save(matrimony) {
    return await matrimony.save();
  }
}

export default new UserRepository();
