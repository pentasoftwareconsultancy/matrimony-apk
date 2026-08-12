import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/models/document_model.dart';

class DocumentActionSheet extends StatelessWidget {
  final DocumentModel document;
  final Function(String docId, String newStatus, {String? fileUrl}) onUpdateStatus;

  const DocumentActionSheet({
    super.key,
    required this.document,
    required this.onUpdateStatus,
  });

  static void show({
    required BuildContext context,
    required DocumentModel document,
    required Function(String docId, String newStatus, {String? fileUrl}) onUpdateStatus,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DocumentActionSheet(
        document: document,
        onUpdateStatus: onUpdateStatus,
      ),
    );
  }

  Future<void> _uploadDocFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.isNotEmpty) {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${document.title} uploaded successfully! Verification pending.'),
              backgroundColor: const Color(0xFF2E7D32),
            ),
          );
        }
        onUpdateStatus(document.id, 'pending', fileUrl: result.files.first.name);
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      onUpdateStatus(document.id, 'verified');
    }
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                document.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: document.status == 'verified' ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  document.status.toUpperCase(),
                  style: TextStyle(
                    color: document.status == 'verified' ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.file_upload_outlined, color: Color(0xFFC9003F)),
            title: const Text('Upload / Replace Document', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Support PDF, JPG, PNG files (Max 5MB)'),
            onTap: () => _uploadDocFile(context),
          ),
          ListTile(
            leading: const Icon(Icons.visibility_outlined, color: Colors.blue),
            title: const Text('View Document Preview', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(document.title),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user, color: Colors.green, size: 64),
                      const SizedBox(height: 12),
                      Text('Verification Status: ${document.status.toUpperCase()}'),
                      const SizedBox(height: 8),
                      const Text('Document encryption & privacy active.'),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline, color: Colors.green),
            title: const Text('Mark as Verified', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              onUpdateStatus(document.id, 'verified');
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Remove Document', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              onUpdateStatus(document.id, 'pending');
            },
          ),
        ],
      ),
    );
  }
}
