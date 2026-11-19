import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/profile_controller.dart';
import 'edit_profile_screen.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../home/presentation/screens/notifications_screen.dart';
import '../../../home/presentation/screens/premium_plans_screen.dart';
import '../../../home/presentation/screens/notification_preferences_screen.dart';
import '../../../home/presentation/screens/language_screen.dart';
import '../../../home/presentation/screens/change_password_screen.dart';
import '../../../home/presentation/screens/partner_preference_screen.dart';
import '../../../home/presentation/screens/events_screen.dart';
import '../../../home/presentation/screens/services_screen.dart';
import '../../../home/presentation/screens/testimonials_screen.dart';
import '../../../home/presentation/screens/blocked_profiles_screen.dart';
import '../../../home/presentation/screens/privacy_settings_screen.dart';
import '../../../home/presentation/screens/help_support_screen.dart';
import '../../../home/presentation/screens/terms_screen.dart';
import '../../../home/presentation/screens/privacy_screen.dart';
import '../../../home/presentation/screens/profile_details_screen.dart';
import '../../../../core/data/dummy_profiles.dart';
import '../../../../core/utils/profile_compatiblity.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n?.logout ?? 'Log out',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          l10n?.logoutConfirm ?? 'Are you sure you want to log out?',
          style: const TextStyle(color: Color(0xFF4A4A4A), fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n?.cancel ?? 'Cancel',
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC9003F),
              minimumSize: const Size(90, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
              l10n?.logout ?? 'Log out',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF888888),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String primaryPhoto, String displayName) {
    final hasValidPhoto = primaryPhoto.trim().isNotEmpty &&
        !primaryPhoto.toLowerCase().contains('unsplash.com') &&
        (primaryPhoto.startsWith('http://') ||
            primaryPhoto.startsWith('https://') ||
            primaryPhoto.startsWith('blob:'));

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFD4DC), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.8),
        child: hasValidPhoto
            ? CachedNetworkImage(
                imageUrl: primaryPhoto.trim(),
                width: 58,
                height: 58,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildAvatarPlaceholder(displayName),
                errorWidget: (context, url, error) => _buildAvatarPlaceholder(displayName),
              )
            : _buildAvatarPlaceholder(displayName),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String displayName) {
    return Container(
      width: 58,
      height: 58,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF0F3),
            Color(0xFFFFD6E0),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xEBFFFFFF),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x14C9003F),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.person_rounded,
              color: Color(0xFFC9003F),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: List.generate(children.length, (index) {
            return Column(
              children: [
                children[index],
                if (index < children.length - 1)
                  const Divider(color: Color(0xFFF2F2F2), height: 1),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: const Color(0xFF757575), size: 20),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1E1E1E),
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFCCCCCC), size: 14),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final profile = profileState.profile;

    final displayName = profile.fullName.trim().isNotEmpty
        ? profile.fullName.trim()
        : ((user?.fullName != null && user!.fullName!.trim().isNotEmpty)
            ? user.fullName!.trim()
            : '');

    final displayMembership = user?.isPremium == true ? 'Premium' : 'free';

    final profilePhotos = profile.photos
        .where((p) => p.trim().isNotEmpty && !p.toLowerCase().contains('unsplash.com'))
        .toList();
    final userPhotos = (user?.photos ?? [])
        .where((p) => p.trim().isNotEmpty && !p.toLowerCase().contains('unsplash.com'))
        .toList();

    final primaryPhoto = profilePhotos.isNotEmpty
        ? profilePhotos.first
        : (userPhotos.isNotEmpty ? userPhotos.first : '');

    final scoreFraction = (profileState.completionPercentage / 100.0).clamp(0.0, 1.0);
    final scorePercentageText = 'Your profile score is ${profileState.completionPercentage.toInt()}%';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9), // Warm off-white background matching reference
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFC9003F),
          onRefresh: () async {
            try {
              await Future.wait([
                ref.read(profileControllerProvider.notifier).loadProfile(),
                ref.read(authControllerProvider.notifier).refreshCurrentUser(),
              ]);
            } catch (_) {}
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER matching screenshot (< Profile + Bell with Red Dot)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            ref.read(homeControllerProvider.notifier).setBottomTab(0);
                          }
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Notification Bell with Red Dot indicator
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0F000000),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.black87,
                            size: 20,
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // PROFILE SUMMARY CARD matching screenshot
              GestureDetector(
                onTap: () async {
                  final profileToView = profile.fullName.isNotEmpty
                      ? MatrimonialProfile.fromProfileModel(profile)
                      : (user != null ? profileFromUser(user) : MatrimonialProfile.empty());
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileDetailsScreen(profile: profileToView),
                    ),
                  );
                  ref.read(profileControllerProvider.notifier).loadProfile();
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEBEBEB)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Avatar Image with refined styling and safe loading
                      _buildProfileAvatar(primaryPhoto, displayName),
                      const SizedBox(width: 14),

                      // Name, ID, Membership & Score
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName.isNotEmpty ? displayName : 'Not Specified',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Membership– ',
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PremiumPlansScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      displayMembership,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFFC9003F),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    ' | ',
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const EditProfileScreen(),
                                        ),
                                      );
                                      ref.read(profileControllerProvider.notifier).loadProfile();
                                    },
                                    child: Text(
                                      '${profileState.completionPercentage.toInt()}% Complete',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFFC9003F),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Progress Bar matching reference
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: scoreFraction,
                                backgroundColor: const Color(0xFFF0F0F0),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC9003F)),
                                minHeight: 4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              scorePercentageText,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ACCOUNT SECTION
              _buildSectionHeader(l10n.settings),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: l10n.viewProfile,
                  onTap: () async {
                    final profileToView = profile.fullName.isNotEmpty
                        ? MatrimonialProfile.fromProfileModel(profile)
                        : (user != null ? profileFromUser(user) : MatrimonialProfile.empty());
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileDetailsScreen(profile: profileToView),
                      ),
                    );
                    ref.read(profileControllerProvider.notifier).loadProfile();
                  },
                ),
                _buildMenuItem(
                  icon: Icons.edit_outlined,
                  title: l10n.editProfile,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                    ref.read(profileControllerProvider.notifier).loadProfile();
                  },
                ),

                _buildMenuItem(
                  icon: Icons.notifications_none_outlined,
                  title: l10n.notificationPreferences,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationPreferencesScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.language_outlined,
                  title: l10n.language,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguageScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: l10n.changePassword,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 20),

              // ACTIVITY SECTION
              _buildSectionHeader(l10n.profileActivity),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.favorite_border_outlined,
                  title: l10n.partnerPreferences,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PartnerPreferenceScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.event_outlined,
                  title: l10n.events,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EventsScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.design_services_outlined,
                  title: l10n.services,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ServicesScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.rate_review_outlined,
                  title: l10n.testimonials,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TestimonialsScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.block_outlined,
                  title: l10n.blockedProfiles,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BlockedProfilesScreen()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 20),

              // SUPPORT SECTION
              _buildSectionHeader(l10n.helpAndSupport),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: l10n.privacySettings,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacySettingsScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: l10n.helpAndSupport,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.description_outlined,
                  title: l10n.termsAndConditions,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TermsScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.policy_outlined,
                  title: l10n.privacyPolicy,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 24),

              // LOG OUT BUTTON matching screenshot
              Center(
                child: ElevatedButton(
                  onPressed: () => _showLogoutDialog(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC9003F),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(130, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.logout,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
