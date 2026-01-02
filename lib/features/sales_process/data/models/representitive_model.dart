class RepresentitiveModel {
  final String email;
  final String name;
  final String phone;
  final String? image;

  RepresentitiveModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.image,
  });

  factory RepresentitiveModel.fromJson(Map<String, dynamic> json) {
    return RepresentitiveModel(
      email: json['email'] ?? "",
      name: json['fullName'] ?? "",
      phone: json['phone'] ?? "",
      image: json['image'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {'email': email, 'name': name, 'phone': phone};
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'RepresentitiveModel(image: $email, name: $name, phone: $phone)';
  }

  // Optional: copyWith method for creating modified copies
  RepresentitiveModel copyWith({
    String? image,
    String? name,
    String? phone,
    String? email,
  }) {
    return RepresentitiveModel(
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      image: image ?? this.image,
    );
  }
}
