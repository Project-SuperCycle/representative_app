class FinanceSnapshotModel {
  final String type;
  final String method;
  final num amount;

  const FinanceSnapshotModel({
    required this.type,
    required this.method,
    required this.amount,
  });

  factory FinanceSnapshotModel.fromJson(Map<String, dynamic> json) {
    return FinanceSnapshotModel(
      type: json['type'] ?? '',
      method: json['method'] ?? '',
      amount: json['amount'] as num? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'method': method, 'amount': amount};
  }

  FinanceSnapshotModel copyWith({String? type, String? method, num? amount}) {
    return FinanceSnapshotModel(
      type: type ?? this.type,
      method: method ?? this.method,
      amount: amount ?? this.amount,
    );
  }

  @override
  String toString() {
    return 'FinanceSnapshotModel(type: $type, method: $method, amount: $amount)';
  }
}
