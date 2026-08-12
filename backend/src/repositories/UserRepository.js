import User from '../models/User.js';

class UserRepository {
  async findByEmail(email) {
    return await User.findOne({ email });
  }

  async findByPhone(phone) {
    return await User.findOne({ phone });
  }

  async findById(id) {
    return await User.findById(id);
  }

  async create(userData) {
    const user = new User(userData);
    return await user.save();
  }

  async update(id, updateData) {
    return await User.findByIdAndUpdate(id, updateData, {
      new: true,
      runValidators: true,
    });
  }

  async delete(id) {
    return await User.findByIdAndDelete(id);
  }

  async save(user) {
    return await user.save();
  }
}

export default new UserRepository();
