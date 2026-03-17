class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String relatedEntity;
  final String relatedEntityId;
  final bool seen;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.relatedEntity,
    required this.relatedEntityId,
    required this.seen,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      relatedEntity: json['relatedEntity'] ?? '',
      relatedEntityId: json['relatedEntityId'] ?? '',
      seen: json['seen'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'body': body,
      'relatedEntity': relatedEntity,
      'relatedEntityId': relatedEntityId,
      'seen': seen,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, body: $body, relatedEntity: $relatedEntity, relatedEntityId: $relatedEntityId, seen: $seen, createdAt: $createdAt)';
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? relatedEntity,
    String? relatedEntityId,
    bool? seen,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      relatedEntity: relatedEntity ?? this.relatedEntity,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      seen: seen ?? this.seen,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper getters للاستخدام في الـ UI
  bool get isRead => seen;

  String get message => body;

  // Format time relative to now (منذ ساعة، منذ يوم، إلخ)
  String get time {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks أسبوع';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'منذ $months شهر';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'منذ $years سنة';
    }
  }
}
