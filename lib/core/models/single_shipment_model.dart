import 'dart:io';
import 'package:supercycle/core/functions/shipment_manager.dart';
import 'package:supercycle/core/models/shipment_trader_model.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/rep_note_model.dart';
import 'package:supercycle/features/representative_shipment_review/data/models/shipment_segment_model.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';
import 'package:supercycle/features/sales_process/data/models/representitive_model.dart';

class SingleShipmentModel {
  final String id;
  final String shipmentNumber;
  final String? customPickupAddress;
  final DateTime requestedPickupAt;
  final String status;
  final String statusDisplay;
  final List<String> uploadedImages;
  final List<File> images;
  final List<DoshItemModel> items;
  final List<DoshItemModel> inspectedItems;
  final String userNotes;
  final num totalQuantityKg;
  final RepresentitiveModel? representitive;
  final ShipmentTraderModel? trader;
  final List<ShipmentNoteModel> mainNotes;
  final List<ShipmentNoteModel> repNotes;
  final List<ShipmentSegmentModel> segments;
  final ShipmentBranchModel? branch;
  final String? type;
  final bool isExtra;
  final bool isFullyWeighted;

  SingleShipmentModel({
    required this.id,
    required this.shipmentNumber,
    required this.customPickupAddress,
    required this.requestedPickupAt,
    required this.status,
    required this.statusDisplay,
    required this.uploadedImages,
    required this.items,
    required this.inspectedItems,
    required this.userNotes,
    required this.totalQuantityKg,
    required this.mainNotes,
    required this.repNotes,
    required this.segments,
    required this.isExtra,
    required this.isFullyWeighted,
    required this.type,
    this.branch,
    this.representitive,
    this.trader,
    this.images = const [],
  });

  factory SingleShipmentModel.fromJson(Map<String, dynamic> json) {
    // Parse all notes first
    List<ShipmentNoteModel> allNotes = json['notes'] != null
        ? List<ShipmentNoteModel>.from(
            json['notes'].map((x) => ShipmentNoteModel.fromJson(x)),
          )
        : [];

    // Filter notes based on authorRole
    List<ShipmentNoteModel> mainNotes = allNotes
        .where((note) => note.authorRole != 'representative')
        .toList();

    List<ShipmentNoteModel> repNotes = allNotes
        .where((note) => note.authorRole == 'representative')
        .toList();

    return SingleShipmentModel(
      id: json['_id'] as String,
      shipmentNumber: json['shipmentNumber'] ?? "",
      customPickupAddress: json['customPickupAddress'],
      requestedPickupAt: DateTime.parse(json['requestedPickupAt'] as String),
      status: json['status'] ?? "",
      statusDisplay: json['statusDisplay'] ?? "",
      uploadedImages: json['uploadedImages'] != null
          ? List<String>.from(json['uploadedImages'])
          : [],
      items: json['items'] != null
          ? List<DoshItemModel>.from(
              json['items'].map((x) => DoshItemModel.fromJson(x)),
            )
          : [],

      inspectedItems: json['inspectedItems'] != null
          ? List<DoshItemModel>.from(
              json['inspectedItems'].map((x) => DoshItemModel.fromJson(x)),
            )
          : [],
      userNotes: json['userNotes'] ?? '',
      totalQuantityKg: json['totalQuantityKg'] as num? ?? 0,
      representitive: json['representativeId'] != null
          ? RepresentitiveModel.fromJson(json['representativeId'])
          : null,
      branch: json['sourceLocationId'] != null
          ? ShipmentBranchModel.fromJson(json['sourceLocationId'])
          : null,
      trader: json['traderId'] != null
          ? ShipmentTraderModel.fromJson(json['traderId'])
          : null,
      mainNotes: mainNotes,
      repNotes: repNotes,
      segments: json['segments'] != null
          ? List<ShipmentSegmentModel>.from(
              json['segments'].map((x) => ShipmentSegmentModel.fromJson(x)),
            )
          : [],
      type: json['type'],
      isExtra: json['isExtra'] ?? false,
      isFullyWeighted: json['isFullyWeighted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    // Combine mainNotes and repNotes back into a single notes array
    List<ShipmentNoteModel> allNotes = [...mainNotes, ...repNotes];

    return {
      '_id': id,
      'shipmentNumber': shipmentNumber,
      'customPickupAddress': customPickupAddress,
      'requestedPickupAt': requestedPickupAt.toIso8601String(),
      'status': status,
      'statusDisplay': statusDisplay,
      'uploadedImages': uploadedImages,
      'items': items.map((item) => item.toJson()).toList(),
      'inspectedItems': inspectedItems.map((item) => item.toJson()).toList(),
      'userNotes': userNotes,
      'sourceLocationId': branch?.toJson(),
      'totalQuantityKg': totalQuantityKg,
      'representitive': representitive?.toJson(),
      'trader': trader?.toJson(),
      'notes': allNotes.map((note) => note.toJson()).toList(),
      'segments': segments.map((segment) => segment.toJson()).toList(),
      'type': type,
      'isExtra': isExtra,
      'isFullyWeighted': isFullyWeighted,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'customPickupAddress': customPickupAddress,
      'requestedPickupAt': requestedPickupAt,
      'items': ShipmentManager.createDoshItemsMap(items: items),
      'inspectedItems': ShipmentManager.createDoshItemsMap(
        items: inspectedItems,
      ),
      'userNotes': userNotes,
      'sourceLocationId': branch?.toJson(),
      'type': type,
      'isExtra': isExtra,
      'isFullyWeighted': isFullyWeighted,
    };
  }

  @override
  String toString() {
    return 'SingleShipmentModel(id: $id, shipmentNumber: $shipmentNumber, customPickupAddress: $customPickupAddress, requestedPickupAt: $requestedPickupAt, status: $status, uploadedImages: $uploadedImages, items: $items, userNotes: $userNotes, totalQuantityKg: $totalQuantityKg, representitive: $representitive, mainNotes: $mainNotes, repNotes: $repNotes, segments: $segments)';
  }

  SingleShipmentModel copyWith({
    String? id,
    String? shipmentNumber,
    String? customPickupAddress,
    DateTime? requestedPickupAt,
    String? status,
    String? statusDisplay,
    List<String>? uploadedImages,
    List<File>? images,
    List<DoshItemModel>? items,
    List<DoshItemModel>? inspectedItems,
    String? userNotes,
    num? totalQuantityKg,
    RepresentitiveModel? representitive,
    ShipmentTraderModel? trader,
    List<ShipmentNoteModel>? mainNotes,
    List<ShipmentNoteModel>? repNotes,
    List<ShipmentSegmentModel>? segments,
    ShipmentBranchModel? branch,
    String? type,
    bool? isExtra,
    bool? isFullyWeighted,
  }) {
    return SingleShipmentModel(
      id: id ?? this.id,
      shipmentNumber: shipmentNumber ?? this.shipmentNumber,
      customPickupAddress: customPickupAddress ?? this.customPickupAddress,
      requestedPickupAt: requestedPickupAt ?? this.requestedPickupAt,
      status: status ?? this.status,
      statusDisplay: statusDisplay ?? this.statusDisplay,
      uploadedImages: uploadedImages ?? this.uploadedImages,
      images: images ?? this.images,
      items: items ?? this.items,
      inspectedItems: inspectedItems ?? this.inspectedItems,
      userNotes: userNotes ?? this.userNotes,
      totalQuantityKg: totalQuantityKg ?? this.totalQuantityKg,
      representitive: representitive ?? this.representitive,
      trader: trader ?? this.trader,
      mainNotes: mainNotes ?? this.mainNotes,
      repNotes: repNotes ?? this.repNotes,
      segments: segments ?? this.segments,
      branch: branch ?? this.branch,
      type: type ?? this.type,
      isExtra: isExtra ?? this.isExtra,
      isFullyWeighted: isFullyWeighted ?? this.isFullyWeighted,
    );
  }
}

class ShipmentBranchModel {
  final String branchName;
  final String address;

  const ShipmentBranchModel({required this.branchName, required this.address});

  factory ShipmentBranchModel.fromJson(Map<String, dynamic> json) {
    return ShipmentBranchModel(
      branchName: json['branchName'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'branchName': branchName, 'address': address};
  }

  @override
  String toString() {
    return 'TraderBranchModel(branchName: $branchName, address: $address)';
  }

  ShipmentBranchModel copyWith({String? branchName, String? address}) {
    return ShipmentBranchModel(
      branchName: branchName ?? this.branchName,
      address: address ?? this.address,
    );
  }
}
