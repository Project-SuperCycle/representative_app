class FinancePaymentModel {
  final String traderId;
  final double amount;
  final String method;
  final String paymentType;
  final DateTime paidAt;
  final List<String> paymentProof;
  final DateTime createdAt;
  final String paymentId;
  final String traderName;
  final List<String> relatedShipmentIds;
  final num relatedShipmentCount;
  final List<String> shipmentNumbers;

  FinancePaymentModel({
    required this.traderId,
    required this.amount,
    required this.method,
    required this.paymentType,
    required this.paidAt,
    required this.paymentProof,
    required this.createdAt,
    required this.paymentId,
    required this.traderName,
    required this.relatedShipmentIds,
    required this.relatedShipmentCount,
    required this.shipmentNumbers,
  });

  factory FinancePaymentModel.fromJson(Map<String, dynamic> json) {
    return FinancePaymentModel(
      traderId: json['traderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      paymentType: json['paymentType'] as String,
      paidAt: DateTime.parse(json['paidAt'] as String),
      paymentProof: List<String>.from(json['paymentProof'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      paymentId: json['paymentId'] as String,
      traderName: json['traderName'] as String,
      relatedShipmentIds:
      List<String>.from(json['relatedShipmentIds'] as List),
      relatedShipmentCount: json['relatedShipmentCount'] as num,
      shipmentNumbers: List<String>.from(json['shipmentNumbers'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'traderId': traderId,
      'amount': amount,
      'method': method,
      'paymentType': paymentType,
      'paidAt': paidAt.toIso8601String(),
      'paymentProof': paymentProof,
      'createdAt': createdAt.toIso8601String(),
      'paymentId': paymentId,
      'traderName': traderName,
      'relatedShipmentIds': relatedShipmentIds,
      'relatedShipmentCount': relatedShipmentCount,
      'shipmentNumbers': shipmentNumbers,
    };
  }

  FinancePaymentModel copyWith({
    String? traderId,
    double? amount,
    String? method,
    String? paymentType,
    DateTime? paidAt,
    List<String>? paymentProof,
    DateTime? createdAt,
    String? paymentId,
    String? traderName,
    List<String>? relatedShipmentIds,
    num? relatedShipmentCount,
    List<String>? shipmentNumbers,
  }) {
    return FinancePaymentModel(
      traderId: traderId ?? this.traderId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      paymentType: paymentType ?? this.paymentType,
      paidAt: paidAt ?? this.paidAt,
      paymentProof: paymentProof ?? this.paymentProof,
      createdAt: createdAt ?? this.createdAt,
      paymentId: paymentId ?? this.paymentId,
      traderName: traderName ?? this.traderName,
      relatedShipmentIds: relatedShipmentIds ?? this.relatedShipmentIds,
      relatedShipmentCount: relatedShipmentCount ?? this.relatedShipmentCount,
      shipmentNumbers: shipmentNumbers ?? this.shipmentNumbers,
    );
  }

  // Helper getters
  bool get isCash => method == 'cash';
  bool get isExternal => paymentType == 'external';
  bool get hasProof => paymentProof.isNotEmpty;

  String getFormattedPaidAt() => _formatArabicDate(paidAt);

  String _formatArabicDate(DateTime date) {
    const List<String> arabicMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${date.day} ${arabicMonths[date.month - 1]} ${date.year}';
  }

  @override
  String toString() {
    return 'FinancePaymentModel(traderId: $traderId, amount: $amount, '
        'method: $method, paymentType: $paymentType, paidAt: $paidAt, '
        'paymentId: $paymentId, traderName: $traderName, '
        'relatedShipmentCount: $relatedShipmentCount)';
  }
}