import 'dart:io';
import 'package:supercycle/core/functions/shipment_manager.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';

class CreateShipmentModel {
  final String? selectedBranchId;
  final String? selectedBranchName;
  final String customPickupAddress;
  final DateTime? requestedPickupAt;
  final List<File> images;
  final List<DoshItemModel> items;
  final String userNotes;

  CreateShipmentModel({
    required this.customPickupAddress,
    required this.requestedPickupAt,
    required this.images,
    required this.items,
    required this.userNotes,
    this.selectedBranchId,
    this.selectedBranchName,
  });

  factory CreateShipmentModel.fromJson(Map<String, dynamic> json) {
    return CreateShipmentModel(
      selectedBranchId: json['sourceLocationId'] as String?,
      customPickupAddress: json['customPickupAddress'] as String,
      requestedPickupAt: DateTime.parse(json['requestedPickupAt'] as String),
      images: json['images'] ?? [] as List<File>,
      items: json['items']
          .map<DoshItemModel>((x) => DoshItemModel.fromJson(x))
          .toList(),
      userNotes: json['userNotes'] as String,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'sourceLocationId': selectedBranchId,
      'customPickupAddress': customPickupAddress,
      'requestedPickupAt': (requestedPickupAt != null)
          ? requestedPickupAt!.toIso8601String()
          : null,
      'images': images,
      'items': items,
      'userNotes': userNotes,
    };
  }

  Map<String, dynamic> toMap({required bool includeCustomPickupAddress}) {
    final map = {
      'requestedPickupAt': requestedPickupAt,
      'items': ShipmentManager.createDoshItemsMap(items: items),
      'userNotes': userNotes,
    };

    if (includeCustomPickupAddress) {
      map['customPickupAddress'] = customPickupAddress;
    } else {
      map['sourceLocationId'] = selectedBranchId;
    }

    return map;
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'ShipmentModel(customPickupAddress: $customPickupAddress, requestedPickupAt: $requestedPickupAt, images: $images, items: $items, userNotes: $userNotes)';
  }

  // Optional: copyWith method for creating modified copies
  CreateShipmentModel copyWith({
    String? selectedBranchId,
    String? selectedBranchName,
    String? customPickupAddress,
    DateTime? requestedPickupAt,
    List<File>? images,
    List<DoshItemModel>? items,
    String? userNotes,
  }) {
    return CreateShipmentModel(
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      selectedBranchName: selectedBranchName ?? this.selectedBranchName,
      customPickupAddress: customPickupAddress ?? this.customPickupAddress,
      requestedPickupAt: requestedPickupAt ?? this.requestedPickupAt,
      images: images ?? this.images,
      items: items ?? this.items,
      userNotes: userNotes ?? this.userNotes,
    );
  }
}
