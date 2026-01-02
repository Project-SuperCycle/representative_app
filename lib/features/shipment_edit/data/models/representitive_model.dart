class RepresentitiveModel {
  final String image;
  final String name;
  final String phone;

  RepresentitiveModel({
    required this.image,
    required this.name,
    required this.phone,
  });

  factory RepresentitiveModel.fromJson(Map<String, dynamic> json) {
    return RepresentitiveModel(
      image: json['image'] as String,
      name: json['name'] ?? "",
      phone: json['phone'] as String,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {'image': image, 'name': name, 'phone': phone};
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'RepresentitiveModel(image: $image, name: $name, phone: $phone)';
  }

  // Optional: copyWith method for creating modified copies
  RepresentitiveModel copyWith({String? image, String? name, String? phone}) {
    return RepresentitiveModel(
      image: image ?? this.image,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}
