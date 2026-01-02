import 'dart:io';

class DeliverSegmentModel {
  final String shipmentID;
  final String segmentID;
  final String receivedByName;
  final List<File> images;

  DeliverSegmentModel({
    required this.shipmentID,
    required this.segmentID,
    required this.receivedByName,
    required this.images,
  });

  factory DeliverSegmentModel.fromJson(Map<String, dynamic> json) {
    return DeliverSegmentModel(
      shipmentID: json['shipmentID'] as String,
      segmentID: json['segmentID'] as String,
      receivedByName: json['receivedByName'] as String,
      images: List<File>.from(json['images'] as List),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'shipmentID': shipmentID,
      'segmentID': segmentID,
      'receivedByName': receivedByName,
      'images': images,
    };
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'DeliverSegmentModel(shipmentID: $shipmentID, segmentID: $segmentID, receivedByName: $receivedByName, images: $images)';
  }

  Map<String, dynamic> toMap() {
    return {'receivedByName': receivedByName};
  }

  // Optional: copyWith method for creating modified copies
  DeliverSegmentModel copyWith({
    String? shipmentID,
    String? segmentID,
    String? receivedByName,
    List<File>? images,
  }) {
    return DeliverSegmentModel(
      shipmentID: shipmentID ?? this.shipmentID,
      segmentID: segmentID ?? this.segmentID,
      receivedByName: receivedByName ?? this.receivedByName,
      images: images ?? this.images,
    );
  }
}
