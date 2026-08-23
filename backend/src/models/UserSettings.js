import mongoose from 'mongoose';

const userSettingsSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true,
  },
  privacySettings: {
    hidePhone: { type: Boolean, default: false },
    hideEmail: { type: Boolean, default: false },
    hidePhotos: { type: Boolean, default: false },
    hideIncome: { type: Boolean, default: false },
    hideLastSeen: { type: Boolean, default: false },
    hideOnlineStatus: { type: Boolean, default: false },
    hideProfile: { type: Boolean, default: false },
  },
  notificationPrefs: {
    push: { type: Boolean, default: true },
    email: { type: Boolean, default: true },
    whatsapp: { type: Boolean, default: false },
  },
  language: {
    type: String,
    default: 'English',
  },
}, {
  timestamps: true,
  collection: 'user_settings',
});

const UserSettings = mongoose.model('UserSettings', userSettingsSchema);
export default UserSettings;
