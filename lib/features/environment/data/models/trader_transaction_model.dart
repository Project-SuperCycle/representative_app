class TraderTransactionModel {
  final String type;
  final num points;
  final String reason;
  final DateTime updatedAt;

  TraderTransactionModel({
    required this.type,
    required this.points,
    required this.reason,
    required this.updatedAt,
  });

  factory TraderTransactionModel.fromJson(Map<String, dynamic> json) {
    return TraderTransactionModel(
      type: json['type'] ?? '',
      points: json['points'] ?? 0,
      reason: json['reason'] ?? '',
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'points': points,
      'reason': reason,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
