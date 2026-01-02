class BusinessInformationModel {
  final String bussinessName;
  final String rawBusinessType;
  final String bussinessAdress;
  final String doshMangerName;
  final String doshMangerPhone;

  BusinessInformationModel({
    required this.bussinessName,
    required this.rawBusinessType,
    required this.bussinessAdress,
    required this.doshMangerName,
    required this.doshMangerPhone,
  });

  // fromJson constructor
  factory BusinessInformationModel.fromJson(Map<String, dynamic> json) {
    return BusinessInformationModel(
      bussinessName: json['bussinessName'] as String,
      rawBusinessType: json['rawBusinessType'] as String,
      bussinessAdress: json['bussinessAdress'] as String,
      doshMangerName: json['doshMangerName'] as String,
      doshMangerPhone: json['doshMangerPhone'] as String,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'bussinessName': bussinessName,
      'rawBusinessType': rawBusinessType,
      'bussinessAdress': bussinessAdress,
      'doshMangerName': doshMangerName,
      'doshMangerPhone': doshMangerPhone,
    };
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'BusinessInformationModel(bussinessName: $bussinessName, rawBusinessType: $rawBusinessType, bussinessAdress: $bussinessAdress, doshMangerName: $doshMangerName, doshMangerPhone: $doshMangerPhone)';
  }

  // Optional: copyWith method for creating modified copies
  BusinessInformationModel copyWith({
    String? bussinessName,
    String? rawBusinessType,
    String? bussinessAdress,
    String? doshMangerName,
    String? doshMangerPhone,
  }) {
    return BusinessInformationModel(
      bussinessName: bussinessName ?? this.bussinessName,
      rawBusinessType: rawBusinessType ?? this.rawBusinessType,
      bussinessAdress: bussinessAdress ?? this.bussinessAdress,
      doshMangerName: doshMangerName ?? this.doshMangerName,
      doshMangerPhone: doshMangerPhone ?? this.doshMangerPhone,
    );
  }
}
