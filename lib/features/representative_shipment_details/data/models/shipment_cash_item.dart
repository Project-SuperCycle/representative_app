class ShipmentCashItem {
  final String shipmentId;
  final String shipmentNumber;
  final double amount;
  final String financialStatus;
  final DateTime requestedPickupAt;
  final DateTime weightedAt;
  final num totalWeightedKg;
  bool isSelected;

  ShipmentCashItem({
    required this.shipmentId,
    required this.shipmentNumber,
    required this.amount,
    required this.financialStatus,
    required this.requestedPickupAt,
    required this.weightedAt,
    required this.totalWeightedKg,
    this.isSelected = false,
  });

  factory ShipmentCashItem.fromJson(Map<String, dynamic> json) {
    return ShipmentCashItem(
      shipmentId: json['shipmentId'] ?? "",
      shipmentNumber: json['shipmentNumber'] ?? "",
      amount: (json['amount'] ?? 0).toDouble(),
      financialStatus: json['financialStatus'] ?? "",
      requestedPickupAt: DateTime.parse(json['requestedPickupAt'] as String),
      weightedAt: DateTime.parse(json['weightedAt'] as String),
      totalWeightedKg: json['totalWeightedKg'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipmentId': shipmentId,
      'shipmentNumber': shipmentNumber,
      'amount': amount,
      'financialStatus': financialStatus,
      'requestedPickupAt': requestedPickupAt.toIso8601String(),
      'weightedAt': weightedAt.toIso8601String(),
      'totalWeightedKg': totalWeightedKg,
    };
  }

  ShipmentCashItem copyWith({
    String? shipmentId,
    String? shipmentNumber,
    double? amount,
    String? financialStatus,
    DateTime? requestedPickupAt,
    DateTime? weightedAt,
    num? totalWeightedKg,
    bool? isSelected,
  }) {
    return ShipmentCashItem(
      shipmentId: shipmentId ?? this.shipmentId,
      shipmentNumber: shipmentNumber ?? this.shipmentNumber,
      amount: amount ?? this.amount,
      financialStatus: financialStatus ?? this.financialStatus,
      requestedPickupAt: requestedPickupAt ?? this.requestedPickupAt,
      weightedAt: weightedAt ?? this.weightedAt,
      totalWeightedKg: totalWeightedKg ?? this.totalWeightedKg,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return 'ShipmentCashItem(shipmentId: $shipmentId, shipmentNumber: $shipmentNumber, amount: $amount, financialStatus: $financialStatus, requestedPickupAt: $requestedPickupAt, weightedAt: $weightedAt, totalWeightedKg: $totalWeightedKg, isSelected: $isSelected)';
  }
}
