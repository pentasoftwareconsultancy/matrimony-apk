import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/l10n_helper.dart';
import '../controllers/home_controller.dart';

class CustomBottomNavBar extends ConsumerWidget {
  final int? selectedIndex;
  final void Function(int index)? onTabSelected;

  const CustomBottomNavBar({
    super.key,
    this.selectedIndex,
    this.onTabSelected,
  });

  void _handleNavigation(BuildContext context, WidgetRef ref, int index) {
    if (onTabSelected != null) {
      onTabSelected!(index);
      return;
    }

    ref.read(homeControllerProvider.notifier).setBottomTab(index);

    if (Navigator.canPop(context)) {
      if (index == 3) {
        // If on a pushed sub-screen (like Edit Profile) and tapping Profile, return to Profile screen
        Navigator.pop(context);
        return;
      } else {
        // Pop all pushed routes back to the root HomeScreen tabs
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final activeIndex = selectedIndex ?? homeState.bottomTabIndex;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(context, ref, 0, Icons.home_rounded, context.l10n.navHome, activeIndex),
          _buildNavItem(context, ref, 1, Icons.favorite_rounded, context.l10n.navLikes, activeIndex),
          _buildNavItem(context, ref, 2, Icons.chat_bubble_rounded, context.l10n.navMessages, activeIndex),
          _buildNavItem(context, ref, 3, Icons.person_rounded, context.l10n.navProfile, activeIndex),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref,
    int index,
    IconData icon,
    String label,
    int activeIndex,
  ) {
    final isSelected = activeIndex == index;

    if (isSelected) {
      return GestureDetector(
        onTap: () => _handleNavigation(context, ref, index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return IconButton(
        icon: Icon(icon, color: Colors.grey.shade400, size: 22),
        onPressed: () => _handleNavigation(context, ref, index),
      );
    }
  }
}

