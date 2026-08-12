import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoManagementDialog extends StatelessWidget {
  final List<String> photos;
  final Function(String pathOrUrl) onUploadPhoto;
  final Function(int index) onRemovePhoto;
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
    required Function(String pathOrUrl) onUploadPhoto,
    required Function(int index) onRemovePhoto,
    required Function(int oldIndex, int newIndex) onReorderPhotos,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => PhotoManagementDialog(
        photos: photos,
        onUploadPhoto: onUploadPhoto,
        onRemovePhoto: onRemovePhoto,
        onReorderPhotos: onReorderPhotos,
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        if (context.mounted) Navigator.pop(context);
        onUploadPhoto(picked.path);
      }
    } catch (e) {
      // Fallback for desktop/simulators without direct camera
      if (context.mounted) Navigator.pop(context);
      onUploadPhoto('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500');
    }
  }

  void _showSamplePhotoPicker(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final samples = [
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500',
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500',
          'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500',
        ];
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Sample Profile Photo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: samples.map((url) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onUploadPhoto(url);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Profile Photos Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            'First photo is treated as your primary profile photo.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),

          // Action Options
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFECEF),
              child: Icon(Icons.photo_camera, color: Color(0xFFC9003F)),
            ),
            title: const Text('Take Photo from Camera', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => _pickImage(context, ImageSource.camera),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFECEF),
              child: Icon(Icons.photo_library, color: Color(0xFFC9003F)),
            ),
            title: const Text('Upload Photo from Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => _pickImage(context, ImageSource.gallery),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFECEF),
              child: Icon(Icons.image_search, color: Color(0xFFC9003F)),
            ),
            title: const Text('Choose Sample Profile Avatar', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => _showSamplePhotoPicker(context),
          ),

          if (photos.isNotEmpty) ...[
            const Divider(height: 24),
            const Text(
              'Uploaded Photos (Tap x to delete)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: index == 0 ? const Color(0xFFC9003F) : Colors.grey.shade300,
                            width: index == 0 ? 2 : 1,
                          ),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(photos[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 14,
                        child: GestureDetector(
                          onTap: () => onRemovePhoto(index),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 12),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
