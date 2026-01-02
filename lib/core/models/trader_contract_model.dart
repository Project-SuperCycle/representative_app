class TraderContractModel {
  final DateTime startDate;
  final DateTime endDate;
  final String paymentMethod;
  final List<String> types;

  // Contract Config
  final num shipmentsInContract;
  final num shipmentsOutsideContract;
  final num totalShipments;
  final num totalDeliveredKg;

  const TraderContractModel({
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
    required this.types,
    required this.shipmentsInContract,
    required this.shipmentsOutsideContract,
    required this.totalShipments,
    required this.totalDeliveredKg,
  });

  factory TraderContractModel.fromJson(Map<String, dynamic> json) {
    return TraderContractModel(
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      paymentMethod: json['paymentMethod'] ?? '',
      types: (json['doshTypes'] != null)
          ? (json['doshTypes'] as List)
                .map((type) => type['name'].toString())
                .toList()
          : [],
      shipmentsInContract: json['totals']['shipmentsInContract'],
      shipmentsOutsideContract: json['totals']['shipmentsOutsideContract'],
      totalShipments: json['totals']['totalShipments'],
      totalDeliveredKg: json['totals']['totalDeliveredKg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'types': types,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'types': types,
      'shipmentsInContract': shipmentsInContract,
      'shipmentsOutsideContract': shipmentsOutsideContract,
      'totalShipments': totalShipments,
      'totalDeliveredKg': totalDeliveredKg,
    };
  }

  TraderContractModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? paymentMethod,
    num? fullQuantity,
    List<String>? types,
    num? shipmentsInContract,
    num? shipmentsOutsideContract,
    num? totalShipments,
    num? totalDeliveredKg,
  }) {
    return TraderContractModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      types: types ?? this.types,
      shipmentsInContract: shipmentsInContract ?? this.shipmentsInContract,
      shipmentsOutsideContract:
          shipmentsOutsideContract ?? this.shipmentsOutsideContract,
      totalShipments: totalShipments ?? this.totalShipments,
      totalDeliveredKg: totalDeliveredKg ?? this.totalDeliveredKg,
    );
  }
}
