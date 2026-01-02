import 'dart:io';
import 'package:supercycle/core/functions/shipment_manager.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';

class UpdateShipmentModel {
  final String shipmentID;
  final List<DoshItemModel> updatedItems;
  final String notes;
  final List<File> images;
  final num rank;

  UpdateShipmentModel({
    required this.shipmentID,
    required this.updatedItems,
    required this.notes,
    required this.images,
    required this.rank,
  });

  factory UpdateShipmentModel.fromJson(Map<String, dynamic> json) {
    return UpdateShipmentModel(
      shipmentID: json['shipmentID'] as String,
      updatedItems: json['updatedItems'] != null
          ? List<DoshItemModel>.from(
              json['updatedItems'].map((x) => DoshItemModel.fromJson(x)),
            )
          : [],
      notes: json['notes'] as String,
      images: [], // Files can't be serialized from JSON
      rank: json['rank'] as num,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'shipmentID': shipmentID,
      'updatedItems': updatedItems,
      'notes': notes,
      'rank': rank,
    };
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'UpdateShipmentModel(shipmentID: $shipmentID, updatedItems: $updatedItems, notes: $notes, images: ${images.length} files, rank: $rank)';
  }

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
      'rank': rank,
      'updatedItems': ShipmentManager.createDoshItemsMap(items: updatedItems),
    };
  }

  // Optional: copyWith method for creating modified copies
  UpdateShipmentModel copyWith({
    String? shipmentID,
    List<DoshItemModel>? updatedItems,
    String? notes,
    List<File>? images,
    num? rank,
  }) {
    return UpdateShipmentModel(
      shipmentID: shipmentID ?? this.shipmentID,
      updatedItems: updatedItems ?? this.updatedItems,
      notes: notes ?? this.notes,
      images: images ?? this.images,
      rank: rank ?? this.rank,
    );
  }
}
