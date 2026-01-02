class TypeHistoryModel {
  final String month;
  final num price;

  TypeHistoryModel({required this.month, required this.price});

  // fromJson constructor
  factory TypeHistoryModel.fromJson(Map<String, dynamic> json) {
    return TypeHistoryModel(
      month: json['month'] as String,
      price: json['marketPrice'] ?? "",
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {'month': month, 'marketPrice': price};
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'TypeHistoryModel(month: $month, pic: $price';
  }

  // Optional: copyWith method for creating modified copies
  TypeHistoryModel copyWith({String? month, num? price}) {
    return TypeHistoryModel(
      month: month ?? this.month,
      price: price ?? this.price,
    );
  }
}
