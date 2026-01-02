class TraderMainBranchModel {
  // Main Branch
  final String? branchName;
  final String? address;
  final String? contactName;
  final String? contactPhone;
  final DateTime? startDate;

  TraderMainBranchModel({
    required this.branchName,
    required this.address,
    required this.contactName,
    required this.contactPhone,
    required this.startDate,
  });

  // Factory constructor for creating a new instance from a map (JSON)
  factory TraderMainBranchModel.fromJson(Map<String, dynamic> json) {
    return TraderMainBranchModel(
      branchName: json['branchName'],
      address: json['address'],
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      startDate: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'branchName': branchName,
      'address': address,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'startDate': DateTime.parse(startDate.toString()),
    };
  }

  // CopyWith method for creating a new instance with updated values
  TraderMainBranchModel copyWith({
    String? branchName,
    String? address,
    String? contactName,
    String? contactPhone,
    DateTime? startDate,
  }) {
    return TraderMainBranchModel(
      branchName: branchName ?? this.branchName,
      address: address ?? this.address,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      startDate: startDate ?? this.startDate,
    );
  }
}
