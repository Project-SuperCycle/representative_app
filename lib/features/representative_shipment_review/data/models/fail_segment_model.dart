import 'dart:io';

class FailSegmentModel {
  final String shipmentID;
  final String segmentID;
  final String reason;
  final List<File> images;

  FailSegmentModel({
    required this.shipmentID,
    required this.segmentID,
    required this.reason,
    this.images = const [],
  });

  factory FailSegmentModel.fromJson(Map<String, dynamic> json) {
    return FailSegmentModel(
      shipmentID: json['shipmentID'] as String,
      segmentID: json['segmentID'] as String,
      reason: json['reason'] as String,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((path) => File(path as String))
              .toList() ??
          [],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'shipmentID': shipmentID,
      'segmentID': segmentID,
      'reason': reason,
      'images': images.map((file) => file.path).toList(),
    };
  }

  // toMap method - returns Map<String, String> without images
  Map<String, String> toMap() {
    return {'reason': reason};
  }

  // toString method for debugging
  @override
  String toString() {
    return 'FailSegmentModel(shipmentID: $shipmentID, segmentID: $segmentID, reason: $reason, images: ${images.length} files)';
  }

  // copyWith method for creating modified copies
  FailSegmentModel copyWith({
    String? shipmentID,
    String? segmentID,
    String? reason,
    List<File>? images,
  }) {
    return FailSegmentModel(
      shipmentID: shipmentID ?? this.shipmentID,
      segmentID: segmentID ?? this.segmentID,
      reason: reason ?? this.reason,
      images: images ?? this.images,
    );
  }
}
