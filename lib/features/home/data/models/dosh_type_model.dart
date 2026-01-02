class DoshTypeModel {
  final String id;
  final String name;
  final String pic;
  final String unit;
  final num minPrice;
  final num maxPrice;

  DoshTypeModel({
    required this.id,
    required this.name,
    required this.pic,
    required this.unit,
    required this.minPrice,
    required this.maxPrice,
  });

  // fromJson constructor
  factory DoshTypeModel.fromJson(Map<String, dynamic> json) {
    return DoshTypeModel(
      id: json['typeId'] as String,
      name: json['name'] as String,
      pic: json['pic'] ?? "",
      unit: json['unit'] as String,
      minPrice: json['priceRange']['min'] as num,
      maxPrice: json['priceRange']['max'] as num,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'typeId': id,
      'name': name,
      'pic': pic,
      'unit': unit,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
    };
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'DoshTypeModel(id: $id ,name: $name, pic: $pic, unit: $unit, minPrice: $minPrice, maxPrice: $maxPrice)';
  }

  // Optional: copyWith method for creating modified copies
  DoshTypeModel copyWith({
    String? id,
    String? name,
    String? pic,
    String? unit,
    num? minPrice,
    num? maxPrice,
  }) {
    return DoshTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      pic: pic ?? this.pic,
      unit: unit ?? this.unit,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}
