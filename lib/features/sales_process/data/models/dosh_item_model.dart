class DoshItemModel {
  final String id;
  final String name;
  final String? unit;
  final num quantity;

  DoshItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    this.unit = "كجم",
  });

  factory DoshItemModel.fromJson(Map<String, dynamic> json) {
    return DoshItemModel(
      id: json['doshType']['_id'] as String,
      name: json['doshType']['name'] ?? "",
      quantity: json['quantityKg'] as num,
      unit: json['unit'] ?? "",
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'quantityKg': quantity, 'unit': unit};
  }

  Map<String, dynamic> toMap() {
    return {'doshType': id, 'quantityKg': quantity};
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'DoshItemModel(id: $id, name: $name, quantity: $quantity, unit: $unit)';
  }

  // Optional: copyWith method for creating modified copies
  DoshItemModel copyWith({
    String? id,
    String? name,
    num? quantity,
    String? unit,
  }) {
    return DoshItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
