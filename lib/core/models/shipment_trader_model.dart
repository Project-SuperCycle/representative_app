class ShipmentTraderModel {
  final String bussinessName;
  final String rawBusinessType;
  final String bussinessAdress;
  final String doshMangerName;
  final String doshMangerPhone;

  ShipmentTraderModel({
    required this.bussinessName,
    required this.rawBusinessType,
    required this.bussinessAdress,
    required this.doshMangerName,
    required this.doshMangerPhone,
  });

  factory ShipmentTraderModel.fromJson(Map<String, dynamic> json) {
    return ShipmentTraderModel(
      bussinessName: json['bussinessName'] ?? "",
      rawBusinessType: json['rawBusinessType'] ?? "",
      bussinessAdress: json['bussinessAdress'] ?? "",
      doshMangerName: json['doshMangerName'] ?? "",
      doshMangerPhone: json['doshMangerPhone'] ?? "",
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
    return 'ShipmentTraderModel(businessName: $bussinessName, rawBusinessType: $rawBusinessType, businessAddress: $bussinessAdress, doshManagerName: $doshMangerName, doshManagerPhone: $doshMangerPhone)';
  }

  // Optional: copyWith method for creating modified copies
  ShipmentTraderModel copyWith({
    String? bussinessName,
    String? rawBusinessType,
    String? bussinessAdress,
    String? doshMangerName,
    String? doshMangerPhone,
  }) {
    return ShipmentTraderModel(
      bussinessName: bussinessName ?? this.bussinessName,
      rawBusinessType: rawBusinessType ?? this.rawBusinessType,
      bussinessAdress: bussinessAdress ?? this.bussinessAdress,
      doshMangerName: doshMangerName ?? this.doshMangerName,
      doshMangerPhone: doshMangerPhone ?? this.doshMangerPhone,
    );
  }
}
