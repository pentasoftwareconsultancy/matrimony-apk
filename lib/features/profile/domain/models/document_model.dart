class DocumentModel {
  final String id;
  final String title;
  final String type; // 'aadhaar', 'pan', 'photos'
  final String status; // 'verified', 'pending', 'rejected'
  final String? fileUrl;
  final String? fileName;
  final DateTime? updatedAt;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.type,
    this.status = 'pending',
    this.fileUrl,
    this.fileName,
    this.updatedAt,
  });

  DocumentModel copyWith({
    String? id,
    String? title,
    String? type,
    String? status,
    String? fileUrl,
    String? fileName,
    DateTime? updatedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'status': status,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: (json['id'] ?? json['type'] ?? '').toString(),
      title: (json['title'] ?? 'Document').toString(),
      type: (json['type'] ?? json['id'] ?? 'document').toString(),
      status: json['status']?.toString() ?? 'pending',
      fileUrl: json['fileUrl']?.toString(),
      fileName: json['fileName']?.toString(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }
}
