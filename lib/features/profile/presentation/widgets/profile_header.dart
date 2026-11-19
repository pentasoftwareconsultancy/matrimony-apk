import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileHeader extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onEditIconTap;

  const ProfileHeader({
    super.key,
    this.onBackTap,
    this.onEditIconTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(88);

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: const Color(0xFFFFFDF9), // Warm off-white background matching reference
      padding: EdgeInsets.only(top: topPadding + 4, left: 16, right: 16, bottom: 8),
      child: Row(
        children: [
          // Back arrow & Profile Title combined
          GestureDetector(
            onTap: onBackTap ??
                () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    context.go('/home');
                  }
                },
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n?.profile ?? 'Profile',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Log out pill button
          GestureDetector(
            onTap: () => _showLogoutDialog(context, ref),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFC9003F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l10n?.logout ?? 'Log out',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
