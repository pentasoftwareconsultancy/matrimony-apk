import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/data/dummy_profiles.dart';
import '../controllers/app_providers.dart';
import 'profile_details_screen.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final unreadCount = ref.watch(notificationProvider.notifier).getUnreadCount();

    // Grouping notifications by type
    final matchAlerts = notifications.where((n) => n.type == 'match').toList();
    final interestAlerts = notifications.where((n) => n.type == 'interest').toList();
    final profileActivity = notifications.where((n) => n.type == 'activity').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          if (unreadCount > 0)
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECEF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount new',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'No notifications yet',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'When you get notifications, they will appear here.',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (matchAlerts.isNotEmpty) ...[
                  _buildSectionHeader('Match alerts'),
                  ...matchAlerts.map((n) => _buildNotificationCard(context, ref, n)),
                  const SizedBox(height: 16),
                ],
                if (interestAlerts.isNotEmpty) ...[
                  _buildSectionHeader('Interest alerts'),
                  ...interestAlerts.map((n) => _buildNotificationCard(context, ref, n)),
                  const SizedBox(height: 16),
                ],
                if (profileActivity.isNotEmpty) ...[
                  _buildSectionHeader('Profile Activity'),
                  ...profileActivity.map((n) => _buildNotificationCard(context, ref, n)),
                ],
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, WidgetRef ref, NotificationItem n) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: n.isRead ? Colors.white : const Color(0xFFFFECEF).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: n.isRead ? Colors.grey.shade200 : const Color(0xFFFFECEF),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(n.profileImage),
        ),
        title: Text(
          n.title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            n.time,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
          ),
        ),
        trailing: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFFFECEF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite_border, color: AppColors.primary, size: 16),
        ),
        onTap: () async {
          ref.read(notificationProvider.notifier).markAsRead(n.id);
          
          if (n.profileId.isNotEmpty) {
            try {
              final apiClient = ref.read(apiClientProvider);
              final response = await apiClient.get('/profile/${n.profileId}');
              final profileData = response.data['data'] as Map<String, dynamic>;
              final profile = MatrimonialProfile.fromJson(profileData);
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileDetailsScreen(profile: profile),
                  ),
                );
              }
            } catch (_) {}
          }
        },
      ),
    );
  }
}
