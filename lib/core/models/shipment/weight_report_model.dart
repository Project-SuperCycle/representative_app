class WeightReportModel {
  final num actualWeightKg;
  final List<String> images;

  WeightReportModel({required this.actualWeightKg, required this.images});

  factory WeightReportModel.fromJson(Map<String, dynamic> json) {
    return WeightReportModel(
      actualWeightKg: json['actualWeightKg'] ?? 0.0,
      images: List<String>.from(json['images']),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {'actualWeightKg': actualWeightKg, 'images': images};
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'WeightReportModel(actualWeightKg: $actualWeightKg, images: $images)';
  }

  // Optional: copyWith method for creating modified copies
  WeightReportModel copyWith({num? actualWeightKg, List<String>? images}) {
    return WeightReportModel(
      actualWeightKg: actualWeightKg ?? this.actualWeightKg,
      images: images ?? this.images,
    );
  }
}
