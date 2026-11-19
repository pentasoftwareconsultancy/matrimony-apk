import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/models/document_model.dart';

class DocumentActionSheet extends StatelessWidget {
  final DocumentModel document;
  final Future<bool> Function(String docId, List<int> bytes, String fileName) onUploadDocument;
  final Future<bool> Function(String docId) onRemoveDocument;

  const DocumentActionSheet({
    super.key,
    required this.document,
    required this.onUploadDocument,
    required this.onRemoveDocument,
  });

  static void show({
    required BuildContext context,
    required DocumentModel document,
    required Future<bool> Function(String docId, List<int> bytes, String fileName) onUploadDocument,
    required Future<bool> Function(String docId) onRemoveDocument,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DocumentActionSheet(
        document: document,
        onUploadDocument: onUploadDocument,
        onRemoveDocument: onRemoveDocument,
      ),
    );
  }

  Future<void> _uploadDocFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final picked = result.files.first;
      List<int>? bytes = picked.bytes;
      if ((bytes == null || bytes.isEmpty) && !kIsWeb && picked.path != null) {
        bytes = await File(picked.path!).readAsBytes();
      }

      if (bytes == null || bytes.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to read selected document file.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (bytes.length > 5 * 1024 * 1024) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Document exceeds the 5MB size limit.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (context.mounted) {
        Navigator.pop(context);
      }

      await onUploadDocument(document.id, bytes, picked.name);
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload ${document.title}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
              final hasUploadedFile = document.fileUrl != null && document.fileUrl!.trim().isNotEmpty;
              final isVerified = document.status == 'verified';
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(document.title),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isVerified ? Icons.verified_user : Icons.hourglass_top,
                        color: isVerified ? Colors.green : Colors.orange,
                        size: 64,
                      ),
                      const SizedBox(height: 12),
                      Text('Verification Status: ${document.status.toUpperCase()}'),
                      const SizedBox(height: 8),
                      Text(
                        hasUploadedFile
                            ? 'Uploaded file: ${document.fileUrl}'
                            : 'No document uploaded yet.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
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
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Remove Document', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              await onRemoveDocument(document.id);
            },
          ),
        ],
      ),
    );
  }
}
