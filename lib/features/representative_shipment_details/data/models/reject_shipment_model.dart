import 'dart:io';

class RejectShipmentModel {
  final String shipmentID;
  final String reason;
  final List<File> images;
  final num rank;

  RejectShipmentModel({
    required this.shipmentID,
    required this.reason,
    required this.images,
    required this.rank,
  });

  factory RejectShipmentModel.fromJson(Map<String, dynamic> json) {
    return RejectShipmentModel(
      shipmentID: json['shipmentID'] as String,
      reason: json['reason'] as String,
      images: json['images'] as List<File>,
      rank: json['rank'] as num,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'shipmentID': shipmentID,
      'reason': reason,
      'images': images,
      'rank': rank,
    };
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'RejectSegmentModel(shipmentID: $shipmentID, reason: $reason, images: $images, rank: $rank)';
  }

  Map<String, dynamic> toMap() {
    return {'reason': reason, 'rank': rank};
  }

  // Optional: copyWith method for creating modified copies
  RejectShipmentModel copyWith({
    String? shipmentID,
    String? reason,
    List<File>? images,
    num? rank,
  }) {
    return RejectShipmentModel(
      shipmentID: shipmentID ?? this.shipmentID,
      reason: reason ?? this.reason,
      images: images ?? this.images,
      rank: rank ?? this.rank,
    );
  }
}
