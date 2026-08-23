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

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log out',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Color(0xFF4A4A4A), fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
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
            child: const Text(
              'Log out',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    final profileState = ref.watch(profileControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final profile = profileState.profile;

    final displayName = (user?.fullName != null && user!.fullName!.trim().isNotEmpty)
        ? user.fullName!
        : (profile.fullName.trim().isNotEmpty ? profile.fullName : 'User Name');

    final displayProfileId = profile.profileId.isNotEmpty
        ? profile.profileId
        : (user != null && user.id.isNotEmpty
            ? 'MEM${user.id.substring(0, user.id.length > 6 ? 6 : user.id.length).toUpperCase()}'
            : 'MEM001');

    final displayMembership = user?.isPremium == true ? 'Premium' : 'free';

    final userPhotos = user?.photos;
    final primaryPhoto = (userPhotos != null && userPhotos.isNotEmpty)
        ? userPhotos.first
        : (profile.photos.isNotEmpty
            ? profile.photos.first
            : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500');

    final scoreFraction = (profileState.completionPercentage / 100.0).clamp(0.0, 1.0);
    final scorePercentageText = 'Your profile score is ${profileState.completionPercentage.toInt()}%';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9), // Warm off-white background matching reference
      body: SafeArea(
        child: SingleChildScrollView(
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
                        Positioned(
                          top: 8,
                          right: 10,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC9003F),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // PROFILE SUMMARY CARD matching screenshot
              Container(
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
                    // Profile Avatar Image
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(primaryPhoto),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Name, ID, Membership & Score
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$displayName | $displayProfileId',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Text(
                                'Membership– ',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              Text(
                                displayMembership,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFC9003F),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                ' | ',
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
                                child: const Text(
                                  'Upgrade now',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFFC9003F),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
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
              const SizedBox(height: 20),

              // ACCOUNT SECTION
              _buildSectionHeader('Account'),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                    ref.read(profileControllerProvider.notifier).loadProfile();
                  },
                ),
                _buildMenuItem(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Upgrade to premium',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PremiumPlansScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.notifications_none_outlined,
                  title: 'Notification preferences',
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
                  title: 'Language',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguageScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Changed password',
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
              _buildSectionHeader('Activity'),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.favorite_border_outlined,
                  title: 'Partner preference',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PartnerPreferenceScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.event_outlined,
                  title: 'Events',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EventsScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.design_services_outlined,
                  title: 'Services',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ServicesScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.rate_review_outlined,
                  title: 'Testimonials',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TestimonialsScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.block_outlined,
                  title: 'Blocked profiles',
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
              _buildSectionHeader('Support'),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacySettingsScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help and support',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.description_outlined,
                  title: 'Terms and Condition',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TermsScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.policy_outlined,
                  title: 'Privacy policy',
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
                  child: const Text(
                    'Log out',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
