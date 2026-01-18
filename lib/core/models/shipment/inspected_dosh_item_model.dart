class InspectedDoshItemModel {
  final String doshType;
  final num quantityKg;

  InspectedDoshItemModel({required this.doshType, required this.quantityKg});

  factory InspectedDoshItemModel.fromJson(Map<String, dynamic> json) {
    return InspectedDoshItemModel(
      doshType: json['doshType'] as String,
      quantityKg: json['quantityKg'] as num,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {'doshType': doshType, 'quantityKg': quantityKg};
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'InspectedDoshItemModel(doshType: $doshType, quantityKg: $quantityKg)';
  }

  // Optional: copyWith method for creating modified copies
  InspectedDoshItemModel copyWith({String? doshType, num? quantityKg}) {
    return InspectedDoshItemModel(
      doshType: doshType ?? this.doshType,
      quantityKg: quantityKg ?? this.quantityKg,
    );
  }
}
