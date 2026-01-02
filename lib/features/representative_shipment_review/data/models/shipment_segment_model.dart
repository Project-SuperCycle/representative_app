import 'package:supercycle/features/representative_shipment_review/data/models/inspected_dosh_item_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/weight_report_model.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';

class ShipmentSegmentModel {
  final String id;
  final String? status;
  final List<DoshItemModel> items;
  final String? destName;
  final String? destAddress;
  final String? vehicleNumber;
  final String? driverName;
  final String? driverPhone;
  final WeightReportModel? weightReport;
  final List<InspectedDoshItemModel>? inspectedItems;

  ShipmentSegmentModel({
    required this.id,
    required this.status,
    required this.items,
    required this.destName,
    required this.destAddress,
    required this.vehicleNumber,
    required this.driverName,
    required this.driverPhone,
    this.weightReport,
    this.inspectedItems,
  });

  factory ShipmentSegmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentSegmentModel(
      id: json['_id'],
      status: json['status'],
      items: List<DoshItemModel>.from(
        json['items'].map((x) => DoshItemModel.fromJson(x)),
      ),
      destName: json['destinationId'] == null
          ? null
          : json['destinationId']['name'],
      destAddress: json['destinationId'] == null
          ? null
          : json['destinationId']['address'] ??
                json['destinationId']['location'],
      vehicleNumber: json['vehicleId'] == null
          ? null
          : json['vehicleId']['licensePlate'],
      driverName: json['vehicleId'] == null
          ? null
          : json['vehicleId']['driverName'],
      driverPhone: json['vehicleId'] == null
          ? null
          : json['vehicleId']['driverPhone'],
      weightReport: json['weightReport'] == null
          ? null
          : WeightReportModel.fromJson(json['weightReport']),
      inspectedItems: json['inspectedItems'] == null
          ? []
          : List<InspectedDoshItemModel>.from(
              json['inspectedItems'].map(
                (x) => InspectedDoshItemModel.fromJson(x),
              ),
            ),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'items': items.map((item) => item.toJson()).toList(),
      'destName': destName,
      'destAddress': destAddress,
      'vehicleNumber': vehicleNumber,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'weightReport': (weightReport == null) ? null : weightReport!.toJson(),
      'inspectedItems': (inspectedItems == null)
          ? null
          : inspectedItems!.map((item) => item.toJson()).toList(),
    };
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'ShipmentSegmentModel(id: $id, status: $status, items: $items, destName: $destName, destAddress: $destAddress, vehicleNumber: $vehicleNumber, driverName: $driverName, driverPhone: $driverPhone, weightReport: $weightReport, inspectedItems: $inspectedItems)';
  }

  // Optional: copyWith method for creating modified copies
  ShipmentSegmentModel copyWith({
    String? id,
    String? status,
    List<DoshItemModel>? items,
    String? destName,
    String? destAddress,
    String? vehicleNumber,
    String? driverName,
    String? driverPhone,
    WeightReportModel? weightReport,
    List<InspectedDoshItemModel>? inspectedItems,
  }) {
    return ShipmentSegmentModel(
      id: id ?? this.id,
      status: status ?? this.status,
      items: items ?? this.items,
      destName: destName ?? this.destName,
      destAddress: destAddress ?? this.destAddress,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      weightReport: weightReport ?? this.weightReport,
      inspectedItems: inspectedItems ?? this.inspectedItems,
    );
  }
}
