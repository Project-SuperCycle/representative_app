class ShipmentNoteModel {
  final String authorRole;
  final String content;
  final List<String>? images;
  final DateTime createdAt;

  ShipmentNoteModel({
    required this.authorRole,
    required this.content,
    this.images,
    required this.createdAt,
  });

  factory ShipmentNoteModel.fromJson(Map<String, dynamic> json) {
    return ShipmentNoteModel(
      authorRole: json['authorRole'] as String,
      content: json['content'] as String,
      images: (json['images'] == null)
          ? null
          : List<String>.from(json['images'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'authorRole': authorRole,
      'content': content,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'RepNoteModel(authorRole: $authorRole, content: $content, images: $images, createdAt: $createdAt)';
  }

  // Optional: copyWith method for creating modified copies
  ShipmentNoteModel copyWith({
    String? authorRole,
    String? content,
    List<String>? images,
    DateTime? createdAt,
  }) {
    return ShipmentNoteModel(
      authorRole: authorRole ?? this.authorRole,
      content: content ?? this.content,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
