import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/data/dummy_profiles.dart';
import '../controllers/app_providers.dart';
import 'profile_details_screen.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends ConsumerState<NotificationsScreen> {

  // ============================================================
  // REFRESH NOTIFICATIONS WHEN SCREEN OPENS
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      debugPrint(
        '[Notifications] Refreshing notifications...',
      );

      ref
          .read(notificationProvider.notifier)
          .refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationProvider);

    final unreadCount =
    ref.watch(notificationProvider.notifier).getUnreadCount();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        actions: [
          if (unreadCount > 0)
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(notificationProvider.notifier)
              .refresh();
        },

        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            32,
          ),
          children: [
            _buildNotificationList(
              context,
              ref,
              notifications,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NOTIFICATION LIST
  // ============================================================

  Widget _buildNotificationList(
      BuildContext context,
      WidgetRef ref,
      List<NotificationItem> notifications,
      ) {
    final profileActivity = notifications
        .where((n) => n.type == 'profileActivity')
        .toList();

    final matchAlerts = notifications
        .where((n) => n.type == 'match')
        .toList();

    final interestAlerts = notifications
        .where((n) => n.type == 'interest')
        .toList();

    final otherNotifications = notifications
        .where(
          (n) =>
      n.type != 'profileActivity' &&
          n.type != 'match' &&
          n.type != 'interest',
    )
        .toList();

    final hasAnySection =
        profileActivity.isNotEmpty ||
            matchAlerts.isNotEmpty ||
            interestAlerts.isNotEmpty ||
            otherNotifications.isNotEmpty;

    if (!hasAnySection) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profileActivity.isNotEmpty) ...[
          _buildSectionHeader(
            'Profile Activity',
            Icons.person_outline,
          ),

          ...profileActivity.map(
                (notification) => _buildNotificationCard(
              context,
              ref,
              notification,
            ),
          ),

          const SizedBox(height: 18),
        ],

        if (matchAlerts.isNotEmpty) ...[
          _buildSectionHeader(
            'Match Alerts',
            Icons.favorite_outline,
          ),

          ...matchAlerts.map(
                (notification) => _buildNotificationCard(
              context,
              ref,
              notification,
            ),
          ),

          const SizedBox(height: 18),
        ],

        if (interestAlerts.isNotEmpty) ...[
          _buildSectionHeader(
            'Interest Alerts',
            Icons.favorite_border,
          ),

          ...interestAlerts.map(
                (notification) => _buildNotificationCard(
              context,
              ref,
              notification,
            ),
          ),

          const SizedBox(height: 18),
        ],

        if (otherNotifications.isNotEmpty) ...[
          _buildSectionHeader(
            'Other',
            Icons.notifications_none,
          ),

          ...otherNotifications.map(
                (notification) => _buildNotificationCard(
              context,
              ref,
              notification,
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader(
      String title,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2,
        bottom: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),

          const SizedBox(width: 6),

          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NOTIFICATION CARD
  // ============================================================

  Widget _buildNotificationCard(
      BuildContext context,
      WidgetRef ref,
      NotificationItem notification,
      ) {
    final isUnread = !notification.isRead;

    return Dismissible(
      key: ValueKey(notification.id),

      // ------------------------------------------------------------
      // SWIPE LEFT ONLY
      // ------------------------------------------------------------
      direction: DismissDirection.endToStart,

      // ------------------------------------------------------------
      // DELETE BACKGROUND
      // ------------------------------------------------------------
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),

        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),

        alignment: Alignment.centerRight,

        padding: const EdgeInsets.only(right: 20),

        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 24,
        ),
      ),

      // ------------------------------------------------------------
      // DELETE FROM BACKEND BEFORE DISMISSING
      // ------------------------------------------------------------
      confirmDismiss: (_) async {
        try {
          await ref
              .read(notificationProvider.notifier)
              .deleteNotification(notification.id);

          return true;
        } catch (error) {
          debugPrint(
            '[Notifications] Delete failed: $error',
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Unable to delete notification',
                ),
              ),
            );
          }

          return false;
        }
      },

      // ------------------------------------------------------------
      // EXISTING NOTIFICATION CARD
      // ------------------------------------------------------------
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

        decoration: BoxDecoration(
          color: isUnread
              ? const Color(0xFFFFF7F8)
              : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: isUnread
                ? const Color(0xFFFFDDE2)
                : Colors.grey.shade200,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            borderRadius: BorderRadius.circular(16),

            onTap: () => _handleNotificationTap(
              context,
              ref,
              notification,
            ),

            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),

              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,

                children: [
                  _buildAvatar(notification),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        Text(
                          notification.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: isUnread
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          notification.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          notification.time,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  if (isUnread)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),

                  const SizedBox(width: 8),

                  _buildNotificationIcon(notification),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar(
      NotificationItem notification,
      ) {
    final imageUrl =
    notification.profileImage.trim();

    return CircleAvatar(
      radius: 24,
      backgroundColor: const Color(0xFFFFECEF),

      child: ClipOval(
        child: imageUrl.isEmpty
            ? const Icon(
          Icons.person_outline,
          color: AppColors.primary,
        )
            : Image.network(
          imageUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,

          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return const Icon(
              Icons.person_outline,
              color: AppColors.primary,
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // NOTIFICATION ICON
  // ============================================================

  Widget _buildNotificationIcon(
      NotificationItem notification,
      ) {
    IconData icon;

    switch (notification.type) {
      case 'profileActivity':
        icon = Icons.visibility_outlined;
        break;

      case 'match':
        icon = Icons.favorite_outline;
        break;

      case 'interest':
        icon = Icons.favorite_border;
        break;

      default:
        icon = Icons.notifications_none;
    }

    return Container(
      width: 32,
      height: 32,

      decoration: const BoxDecoration(
        color: Color(0xFFFFECEF),
        shape: BoxShape.circle,
      ),

      child: Icon(
        icon,
        color: AppColors.primary,
        size: 16,
      ),
    );
  }

  // ============================================================
  // TAP HANDLER
  // ============================================================

  Future<void> _handleNotificationTap(
      BuildContext context,
      WidgetRef ref,
      NotificationItem notification,
      ) async {
    debugPrint(
      '========================================',
    );

    debugPrint(
      'NOTIFICATION TAPPED',
    );

    debugPrint(
      'Notification ID: ${notification.id}',
    );

    debugPrint(
      'Notification title: ${notification.title}',
    );

    debugPrint(
      'Notification subtitle: ${notification.subtitle}',
    );

    debugPrint(
      'Notification type: ${notification.type}',
    );

    debugPrint(
      'Notification profileId: ${notification.profileId}',
    );

    debugPrint(
      '========================================',
    );

    try {
      // ==========================================================
      // 1. MARK NOTIFICATION AS READ
      // ==========================================================

      await ref
          .read(notificationProvider.notifier)
          .markAsRead(notification.id);

      debugPrint(
        '[Notification] Marked as read: ${notification.id}',
      );

      // ==========================================================
      // 2. VALIDATE PROFILE ID
      // ==========================================================

      final profileId =
      notification.profileId.trim();

      if (profileId.isEmpty) {
        debugPrint(
          '[Notification] ERROR: profileId is empty',
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'This notification has no profile attached.',
              ),
            ),
          );
        }

        return;
      }

      // ==========================================================
      // 3. FETCH ACTUAL PROFILE
      // ==========================================================

      final apiClient =
      ref.read(apiClientProvider);

      debugPrint(
        '[Notification] Fetching profile: $profileId',
      );

      final response = await apiClient.get(
        '/profile/$profileId',
      );

      // ==========================================================
      // DEBUG API RESPONSE
      // ==========================================================

      debugPrint(
        '========== NOTIFICATION PROFILE RESPONSE ==========',
      );

      debugPrint(
        'STATUS: ${response.statusCode}',
      );

      debugPrint(
        'DATA: ${response.data}',
      );

      debugPrint(
        '====================================================',
      );

      // ==========================================================
      // 4. VALIDATE API RESPONSE
      // ==========================================================

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception(
          'Invalid profile response format',
        );
      }

      final rawData =
      responseData['data'];

      if (rawData == null) {
        throw Exception(
          'Profile response contains no data',
        );
      }

      if (rawData is! Map<String, dynamic>) {
        throw Exception(
          'Profile data has invalid format',
        );
      }

      // ==========================================================
      // IMPORTANT:
      //
      // Backend response is:
      //
      // data: {
      //   profile: {
      //     id: "...",
      //     fullName: "...",
      //     ...
      //   }
      // }
      //
      // So we need data['profile'], NOT data directly.
      // ==========================================================

      final profileObject =
      rawData['profile'];

      if (profileObject == null) {
        throw Exception(
          'Profile object not found in response',
        );
      }

      if (profileObject is! Map<String, dynamic>) {
        throw Exception(
          'Profile object has invalid format',
        );
      }

      final profileData =
      Map<String, dynamic>.from(
        profileObject,
      );

      // ==========================================================
      // DEBUG PROFILE DATA
      // ==========================================================

      debugPrint(
        '[Notification] Profile data ID: '
            '${profileData['_id'] ?? profileData['id']}',
      );

      debugPrint(
        '[Notification] Profile name: '
            '${profileData['fullName'] ?? profileData['name']}',
      );

      // ==========================================================
      // 5. CONVERT TO MATRIMONIAL PROFILE
      // ==========================================================

      final profile =
      MatrimonialProfile.fromJson(
        profileData,
      );

      debugPrint(
        '[Notification] Profile parsed successfully',
      );

      debugPrint(
        '[Notification] Parsed profile ID: '
            '${profile.id}',
      );

      debugPrint(
        '[Notification] Parsed profile name: '
            '${profile.fullName}',
      );

      // ==========================================================
      // 6. FINAL VALIDATION
      // ==========================================================

      if (profile.id.trim().isEmpty) {
        throw Exception(
          'Profile was loaded but profile ID is empty',
        );
      }

      // ==========================================================
      // 7. OPEN ACTUAL PROFILE
      // ==========================================================

      if (!context.mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileDetailsScreen(
            profile: profile,
          ),
        ),
      );

      debugPrint(
        '[Notification] Navigated to profile: '
            '${profile.id}',
      );

      debugPrint(
        '[Notification] Profile name: '
            '${profile.fullName}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        '========================================',
      );

      debugPrint(
        '[Notification] OPEN PROFILE ERROR',
      );

      debugPrint(
        'Notification ID: ${notification.id}',
      );

      debugPrint(
        'Profile ID: ${notification.profileId}',
      );

      debugPrint(
        'Error: $error',
      );

      debugPrint(
        'StackTrace: $stackTrace',
      );

      debugPrint(
        '========================================',
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to open profile: $error',
          ),
        ),
      );
    }
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Container(
              width: 86,
              height: 86,

              decoration: const BoxDecoration(
                color: Color(0xFFFFF1F3),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.notifications_none,
                size: 42,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No notifications yet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'When you receive notifications, '
                  'they will appear here.',
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}