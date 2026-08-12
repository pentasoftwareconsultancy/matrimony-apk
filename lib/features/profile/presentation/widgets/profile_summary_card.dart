import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/profile_model.dart';

class ProfileSummaryCard extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback onPhotoTap;
  final Function(int index) onThumbnailTap;
  final VoidCallback onEditBioTap;

  const ProfileSummaryCard({
    super.key,
    required this.profile,
    required this.onPhotoTap,
    required this.onThumbnailTap,
    required this.onEditBioTap,
  });

  @override
  Widget build(BuildContext context) {
    final photos = profile.photos;
    final primaryPhoto = photos.isNotEmpty
        ? photos.first
        : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Profile Photo
              GestureDetector(
                onTap: onPhotoTap,
                child: Stack(
                  children: [
                    Container(
                      width: 105,
                      height: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(primaryPhoto),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFC9003F),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Name, Age, Tag & Bio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Age text header matching reference screenshot
                    Text(
                      '${profile.fullName}, age– ${profile.age}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Tag Badge (e.g. MODIFYING)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFECEF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        profile.tag.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFC9003F),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // About me description text matching reference
                    GestureDetector(
                      onTap: onEditBioTap,
                      child: Text(
                        profile.aboutMe.isNotEmpty
                            ? profile.aboutMe
                            : 'Tap to add about me description...',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Small photo thumbnails row below main image
          Row(
            children: [
              for (int i = 0; i < 4; i++) ...[
                GestureDetector(
                  onTap: () => onThumbnailTap(i),
                  child: Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: i == 0 ? const Color(0xFFC9003F) : Colors.grey.shade300,
                        width: i == 0 ? 1.5 : 1.0,
                      ),
                      image: i < photos.length
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(photos[i]),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Colors.grey.shade200,
                    ),
                    child: i >= photos.length
                        ? const Icon(Icons.add, size: 14, color: Colors.grey)
                        : null,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
