class FinanceSnapshotModel {
  final String type;
  final String method;
  final num amount;
  final DateTime calculatedAt;

  const FinanceSnapshotModel({
    required this.type,
    required this.method,
    required this.amount,
    required this.calculatedAt,
  });

  factory FinanceSnapshotModel.fromJson(Map<String, dynamic> json) {
    return FinanceSnapshotModel(
      type: json['type'] ?? '',
      method: json['method'] ?? '',
      amount: json['amount'] as num? ?? 0,
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'method': method,
      'amount': amount,
      'calculatedAt': calculatedAt.toIso8601String(),
    };
  }

  FinanceSnapshotModel copyWith({
    String? type,
    String? method,
    num? amount,
    DateTime? calculatedAt,
  }) {
    return FinanceSnapshotModel(
      type: type ?? this.type,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      calculatedAt: calculatedAt ?? this.calculatedAt,
    );
  }

  @override
  String toString() {
    return 'FinanceSnapshotModel(type: $type, method: $method, amount: $amount, calculatedAt: $calculatedAt)';
  }
}
