import 'dart:io';

class AcceptShipmentModel {
  final String shipmentID;
  final String notes;
  final List<File> images;
  final num rank;

  AcceptShipmentModel({
    required this.shipmentID,
    required this.notes,
    required this.images,
    required this.rank,
  });

  factory AcceptShipmentModel.fromJson(Map<String, dynamic> json) {
    return AcceptShipmentModel(
      shipmentID: json['shipmentID'] as String,
      notes: json['notes'] as String,
      images: json['images'] as List<File>,
      rank: json['rank'] as num,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'shipmentID': shipmentID,
      'notes': notes,
      'images': images,
      'rank': rank,
    };
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'AcceptShipmentModel(shipmentID: $shipmentID, notes: $notes, images: $images, rank: $rank)';
  }

  Map<String, dynamic> toMap() {
    return {'notes': notes, 'rank': rank};
  }

  // Optional: copyWith method for creating modified copies
  AcceptShipmentModel copyWith({
    String? shipmentID,
    String? notes,
    List<File>? images,
    num? rank,
  }) {
    return AcceptShipmentModel(
      shipmentID: shipmentID ?? this.shipmentID,
      notes: notes ?? this.notes,
      images: images ?? this.images,
      rank: rank ?? this.rank,
    );
  }
}
