import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/profile_controller.dart';

class PhotoManagementDialog extends ConsumerWidget {
  static const int maxPhotos = 6;

  final List<String> photos;
  final ValueChanged<XFile> onUploadPhoto;
  final ValueChanged<int> onRemovePhoto;
  final Function(int oldIndex, int newIndex) onReorderPhotos;

  const PhotoManagementDialog({
    super.key,
    required this.photos,
    required this.onUploadPhoto,
    required this.onRemovePhoto,
    required this.onReorderPhotos,
  });

  static void showOptions({
    required BuildContext context,
    required List<String> photos,
    required ValueChanged<XFile> onUploadPhoto,
    required ValueChanged<int> onRemovePhoto,
    required Function(int oldIndex, int newIndex) onReorderPhotos,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: PhotoManagementDialog(
          photos: photos,
          onUploadPhoto: onUploadPhoto,
          onRemovePhoto: onRemovePhoto,
          onReorderPhotos: onReorderPhotos,
        ),
      ),
    );
  }

  Future<void> _pickImage(
      BuildContext context,
      ImageSource source,
      List<String> currentPhotos,
      ) async {
    if (currentPhotos.length >= maxPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 6 profile photos are allowed.')),
      );
      return;
    }

    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );

      if (picked == null || !context.mounted) return;
      Navigator.of(context).pop();
      onUploadPhoto(picked);
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'Could not open the camera. Please try the gallery.'
                : 'Could not select the image. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the shared profile state so the thumbnail list rebuilds
    // immediately when a photo is removed or added.
    final currentPhotos = ref.watch(profileControllerProvider).profile.photos;
    final hasReachedLimit = currentPhotos.length >= maxPhotos;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Profile Photos Management',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${currentPhotos.length} of $maxPhotos photos uploaded. You can add up to ${maxPhotos - currentPhotos.length} more.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFECEF),
              child: Icon(Icons.photo_camera, color: Color(0xFFC9003F)),
            ),
            title: const Text(
              'Take Photo from Camera',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            enabled: !hasReachedLimit,
            onTap: hasReachedLimit
                ? null
                : () => _pickImage(context, ImageSource.camera, currentPhotos),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFECEF),
              child: Icon(Icons.photo_library, color: Color(0xFFC9003F)),
            ),
            title: const Text(
              'Upload Photo from Gallery',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            enabled: !hasReachedLimit,
            onTap: hasReachedLimit
                ? null
                : () => _pickImage(context, ImageSource.gallery, currentPhotos),
          ),
          if (hasReachedLimit)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'You have reached the 6-photo limit. Delete a photo to add another.',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
            ),
          if (currentPhotos.isNotEmpty) ...[
            const Divider(height: 24),
            const Text(
              'Saved Photos (Tap × to delete)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 78,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: currentPhotos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 68,
                    height: 72,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: currentPhotos[index],
                                fit: BoxFit.cover,
                                placeholder: (_, __) => const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (_, __, ___) => const Center(
                                  child: Icon(Icons.broken_image_outlined),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Material(
                            color: Colors.red,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => onRemovePhoto(index),
                              child: const SizedBox(
                                width: 22,
                                height: 22,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
