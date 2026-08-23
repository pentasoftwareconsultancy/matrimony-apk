import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/dummy_profiles.dart';
import '../controllers/app_providers.dart';
import '../controllers/home_controller.dart';
import 'profile_details_screen.dart';
import 'chat_screen.dart';

class ProfileViewsScreen extends ConsumerWidget {
  const ProfileViewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final viewState = ref.watch(profileViewProvider);
    final viewedProfiles = viewState.viewerProfiles;

    // Grouping: first 3 are "Today", rest are "Earlier"
    final todayProfiles = viewedProfiles.take(3).toList();
    final earlierProfiles = viewedProfiles.skip(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profile views',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'People who visited your profile',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // "13 viewed" badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECEF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${viewedProfiles.length} viewed',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Profiles list
            Expanded(
              child: viewedProfiles.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.visibility_off_outlined, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            'No profile views yet',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      children: [
                        if (todayProfiles.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Today',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ...todayProfiles.map((p) => _buildViewCard(context, ref, p, homeState)),
                          const SizedBox(height: 16),
                        ],
                        if (earlierProfiles.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Earlier',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ...earlierProfiles.map((p) => _buildViewCard(context, ref, p, homeState)),
                        ]
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewCard(BuildContext context, WidgetRef ref, MatrimonialProfile p, HomeState homeState) {
    final isFav = homeState.favouriteIds.contains(p.id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileDetailsScreen(profile: p)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Avatar Photo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(p.photos.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.fullName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Age ${p.age} • ${p.occupation}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '${p.city}, ${p.state}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Highlight Pills
                      Row(
                        children: [
                          _buildMiniPill('Same religion', const Color(0xFFFFECEF), AppColors.primary),
                          const SizedBox(width: 6),
                          _buildMiniPill('Nearby city', const Color(0xFFE8F4FD), const Color(0xFF1E88E5)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Hobbies match subtitle
                      Row(
                        children: [
                          const Icon(Icons.star_border, size: 10, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'You both love ${p.hobbies.take(2).join(" & ").toLowerCase()}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 9,
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action Buttons on Right
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Heart Fav Toggle
                    GestureDetector(
                      onTap: () {
                        ref.read(homeControllerProvider.notifier).toggleFavourite(p.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isFav ? const Color(0xFFFFECEF) : Colors.grey.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isFav ? AppColors.primary : Colors.grey.shade200,
                          ),
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: isFav ? AppColors.primary : Colors.grey.shade400,
                          size: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Chat Trigger
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(
                              name: p.fullName,
                              avatarUrl: p.photos.first,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.grey.shade600,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniPill(String label, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textCol,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}