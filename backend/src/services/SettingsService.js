import UserSettings from '../models/UserSettings.js';

class SettingsService {
  async getSettings(userId) {
    let settings = await UserSettings.findOne({ userId });
    if (!settings) {
      settings = await UserSettings.create({ userId });
    }
    return settings;
  }

  async updatePrivacySettings(userId, privacySettings) {
    const settings = await this.getSettings(userId);
    settings.privacySettings = {
      ...settings.privacySettings,
      ...privacySettings,
    };
    await settings.save();
    return settings;
  }

  async updateNotificationPrefs(userId, notificationPrefs) {
    const settings = await this.getSettings(userId);
    settings.notificationPrefs = {
      ...settings.notificationPrefs,
      ...notificationPrefs,
    };
    await settings.save();
    return settings;
  }

  async updateLanguage(userId, language) {
    const settings = await this.getSettings(userId);
    settings.language = language;
    await settings.save();
    return settings;
  }
}

export default new SettingsService();
