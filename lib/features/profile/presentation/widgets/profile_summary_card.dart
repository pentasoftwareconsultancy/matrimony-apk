import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/profile_model.dart';
import '../../../../core/localization/l10n_helper.dart';

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
    final photos = profile.photos
        .where((p) => p.trim().isNotEmpty && !p.toLowerCase().contains('unsplash.com'))
        .toList();
    final primaryPhoto = photos.isNotEmpty ? photos.first : '';

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
                        border: Border.all(color: const Color(0xFFFFD4DC), width: 1.2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.8),
                        child: (primaryPhoto.isNotEmpty &&
                                (primaryPhoto.startsWith('http://') ||
                                    primaryPhoto.startsWith('https://') ||
                                    primaryPhoto.startsWith('blob:')))
                            ? CachedNetworkImage(
                                imageUrl: primaryPhoto,
                                width: 105,
                                height: 125,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => _buildPlaceholder(),
                                errorWidget: (context, url, error) => _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
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
                      context.isMarathi
                          ? '${profile.fullName}, वय– ${profile.age}'
                          : '${profile.fullName}, age– ${profile.age}',
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
                        context.tr(profile.tag).toUpperCase(),
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
                            : (context.isMarathi ? 'माहिती दिलेली नाही' : 'Not Specified'),
                        style: TextStyle(
                          color: profile.aboutMe.isNotEmpty ? Colors.grey.shade700 : Colors.grey.shade400,
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
                      color: Colors.grey.shade100,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: i < photos.length
                          ? CachedNetworkImage(
                              imageUrl: photos[i],
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(color: Colors.grey.shade200),
                              errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 14, color: Colors.grey),
                            )
                          : const Icon(Icons.add, size: 14, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 105,
      height: 125,
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
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xEBFFFFFF),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x14C9003F),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.person_rounded,
              color: Color(0xFFC9003F),
              size: 34,
            ),
          ),
        ),
      ),
    );
  }
}
