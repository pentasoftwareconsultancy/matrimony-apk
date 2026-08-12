import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/app_providers.dart';

class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  ConsumerState<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  bool _hidePhone = false;
  bool _hideEmail = false;
  bool _hidePhotos = false;
  bool _hideIncome = false;
  bool _hideLastSeen = false;
  bool _hideOnlineStatus = false;
  bool _hideProfile = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(privacySettingsProvider);
    if (!_initialized) {
      _hidePhone = settings.hidePhone;
      _hideEmail = settings.hideEmail;
      _hidePhotos = settings.hidePhotos;
      _hideIncome = settings.hideIncome;
      _hideLastSeen = settings.hideLastSeen;
      _hideOnlineStatus = settings.hideOnlineStatus;
      _hideProfile = settings.hideProfile;
      _initialized = true;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Control who can view your personal information',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),

          // Settings List Card
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildPrivacyToggleTile(
                        title: 'Hide Phone Number',
                        subtitle: 'Only accepted matches can see your phone number',
                        value: _hidePhone,
                        onChanged: (val) => setState(() => _hidePhone = val),
                      ),
                      Divider(color: Colors.grey.shade100, height: 1),
                      _buildPrivacyToggleTile(
                        title: 'Hide Email Address',
                        subtitle: 'Keep your email address private on your profile',
                        value: _hideEmail,
                        onChanged: (val) => setState(() => _hideEmail = val),
                      ),
                      Divider(color: Colors.grey.shade100, height: 1),
                      _buildPrivacyToggleTile(
                        title: 'Hide Photos',
                        subtitle: 'Only premium or accepted matches can see your photos',
                        value: _hidePhotos,
                        onChanged: (val) => setState(() => _hidePhotos = val),
                      ),
                      Divider(color: Colors.grey.shade100, height: 1),
                      _buildPrivacyToggleTile(
                        title: 'Hide Annual Income',
                        subtitle: 'Keep your annual income hidden from other users',
                        value: _hideIncome,
                        onChanged: (val) => setState(() => _hideIncome = val),
                      ),
                      Divider(color: Colors.grey.shade100, height: 1),
                      _buildPrivacyToggleTile(
                        title: 'Hide Last Seen',
                        subtitle: 'Do not show your last active timestamp',
                        value: _hideLastSeen,
                        onChanged: (val) => setState(() => _hideLastSeen = val),
                      ),
                      Divider(color: Colors.grey.shade100, height: 1),
                      _buildPrivacyToggleTile(
                        title: 'Hide Online Status',
                        subtitle: 'Do not show when you are currently online',
                        value: _hideOnlineStatus,
                        onChanged: (val) => setState(() => _hideOnlineStatus = val),
                      ),
                      Divider(color: Colors.grey.shade100, height: 1),
                      _buildPrivacyToggleTile(
                        title: 'Hide Profile completely',
                        subtitle: 'Temporarily hide your profile from search results',
                        value: _hideProfile,
                        onChanged: (val) => setState(() => _hideProfile = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                final updatedSettings = PrivacySettings(
                  hidePhone: _hidePhone,
                  hideEmail: _hideEmail,
                  hidePhotos: _hidePhotos,
                  hideIncome: _hideIncome,
                  hideLastSeen: _hideLastSeen,
                  hideOnlineStatus: _hideOnlineStatus,
                  hideProfile: _hideProfile,
                );
                await ref.read(privacySettingsProvider.notifier).save(updatedSettings);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Privacy settings saved locally.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}
