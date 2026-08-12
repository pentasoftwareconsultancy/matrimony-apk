import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    trim: true,
    lowercase: true,
    unique: true,
    sparse: true,
  },
  phone: {
    type: String,
    trim: true,
    unique: true,
    sparse: true,
  },
  password: {
    type: String,
  },
  profileCompleted: {
    type: Boolean,
    default: false,
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  role: {
    type: String,
    enum: ['user', 'admin'],
    default: 'user',
  },
  otp: {
    code: { type: String },
    expiresAt: { type: Date },
    type: { type: String, enum: ['login', 'verification', 'reset_password'] }
  }
}, {
  timestamps: true,
  collection: 'users'
});

const User = mongoose.model('User', userSchema);
export default User;
