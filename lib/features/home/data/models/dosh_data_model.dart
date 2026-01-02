class DoshDataModel {
  final String name;
  final String id;

  DoshDataModel({required this.name, required this.id});

  // fromJson constructor
  factory DoshDataModel.fromJson(Map<String, dynamic> json) {
    return DoshDataModel(name: json['name'] as String, id: json['id'] ?? "");
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id};
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'DoshDataModel(name: $name, id: $id)';
  }

  // Optional: copyWith method for creating modified copies
  DoshDataModel copyWith({String? name, String? id}) {
    return DoshDataModel(name: name ?? this.name, id: id ?? this.id);
  }
}
