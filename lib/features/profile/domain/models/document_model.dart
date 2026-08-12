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
    this.status = 'verified',
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
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      status: json['status'] as String? ?? 'verified',
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }
}
