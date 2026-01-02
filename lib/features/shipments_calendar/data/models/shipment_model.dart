class ShipmentModel {
  final String id;
  final String shipmentNumber;
  final String customPickupAddress;
  final DateTime requestedPickupAt;
  final String status;
  final num totalQuantityKg;
  final String type;
  final bool isExtra;

  ShipmentModel({
    required this.id,
    required this.shipmentNumber,
    required this.customPickupAddress,
    required this.requestedPickupAt,
    required this.status,
    required this.totalQuantityKg,
    required this.type,
    required this.isExtra,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['_id'] ?? "",
      shipmentNumber: json['shipmentNumber'] ?? "",
      customPickupAddress: json['customPickupAddress'] ?? json['address'] ?? "",
      requestedPickupAt: DateTime.parse(json['requestedPickupAt'] as String),
      status: json['statusDisplay'] ?? "",
      totalQuantityKg: json['totalQuantityKg'] ?? json['actualQuantityKg'] ?? 0,
      type: json['type'] ?? "",
      isExtra: json['isExtra'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'shipmentNumber': shipmentNumber,
      'customPickupAddress': customPickupAddress,
      'requestedPickupAt': requestedPickupAt.toIso8601String(),
      'status': status,
      'totalQuantityKg': totalQuantityKg,
      'type': type,
      'isExtra': isExtra,
    };
  }

  @override
  String toString() {
    return 'ShipmentModel(id: $id, shipmentNumber: $shipmentNumber, customPickupAddress: $customPickupAddress, requestedPickupAt: $requestedPickupAt, status: $status, totalQuantityKg: $totalQuantityKg, type: $type, isExtra: $isExtra)';
  }

  ShipmentModel copyWith({
    String? id,
    String? shipmentNumber,
    String? customPickupAddress,
    DateTime? requestedPickupAt,
    String? status,
    num? totalQuantityKg,
    String? type,
    bool? isExtra,
  }) {
    return ShipmentModel(
      id: id ?? this.id,
      shipmentNumber: shipmentNumber ?? this.shipmentNumber,
      customPickupAddress: customPickupAddress ?? this.customPickupAddress,
      requestedPickupAt: requestedPickupAt ?? this.requestedPickupAt,
      status: status ?? this.status,
      totalQuantityKg: totalQuantityKg ?? this.totalQuantityKg,
      type: type ?? this.type,
      isExtra: isExtra ?? this.isExtra,
    );
  }
}
