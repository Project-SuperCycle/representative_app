class StartSegmentModel {
  final String shipmentID;
  final String segmentID;

  StartSegmentModel({required this.shipmentID, required this.segmentID});

  factory StartSegmentModel.fromJson(Map<String, dynamic> json) {
    return StartSegmentModel(
      shipmentID: json['shipmentID'] as String,
      segmentID: json['segmentID'] as String,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {'shipmentID': shipmentID, 'segmentID': segmentID};
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'StartSegmentModel(shipmentID: $shipmentID, segmentID: $segmentID)';
  }

  // Optional: copyWith method for creating modified copies
  StartSegmentModel copyWith({String? shipmentID, String? segmentID}) {
    return StartSegmentModel(
      shipmentID: shipmentID ?? this.shipmentID,
      segmentID: segmentID ?? this.segmentID,
    );
  }
}
