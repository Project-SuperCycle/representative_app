class TraderBranchModel {
  final String branchId;
  final String branchName;
  final String address;
  final String contactName;
  final String contactPhone;
  final int deliveryVolume;
  final List<String> recyclableTypes;
  final List<int> deliverySchedule; // تغير من String لـ List<int>

  const TraderBranchModel({
    required this.branchId,
    required this.branchName,
    required this.address,
    required this.contactName,
    required this.contactPhone,
    required this.deliveryVolume,
    required this.recyclableTypes,
    required this.deliverySchedule,
  });

  factory TraderBranchModel.fromJson(Map<String, dynamic> json) {
    // استخراج shipmentDays من contractConfig
    List<int> shipmentDays = [];
    if (json['contractConfig'] != null &&
        json['contractConfig']['shipmentDays'] != null) {
      shipmentDays = List<int>.from(json['contractConfig']['shipmentDays']);
    }

    // استخراج recyclableTypes من stats
    List<String> types = [];
    if (json['stats'] != null &&
        json['stats']['doshType'] != null &&
        json['stats']['doshType']['name'] != null) {
      types = [json['stats']['doshType']['name']];
    }

    return TraderBranchModel(
      branchId: json['branchId'] ?? '',
      branchName: json['branchName'] ?? '',
      address: json['address'] ?? '',
      contactName: json['contactName'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      deliveryVolume: json['stats']?['totalDeliveredKg'] ?? 0,
      recyclableTypes: types,
      deliverySchedule: shipmentDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'address': address,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'deliveryVolume': deliveryVolume,
      'recyclableTypes': recyclableTypes,
      'deliverySchedule': deliverySchedule,
    };
  }

  // toMap method for storage (same as toJson for this model)
  Map<String, dynamic> toMap() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'address': address,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'deliveryVolume': deliveryVolume,
      'recyclableTypes': recyclableTypes,
      'deliverySchedule': deliverySchedule,
    };
  }

  // fromMap method for retrieving from storage
  factory TraderBranchModel.fromMap(Map<String, dynamic> map) {
    return TraderBranchModel(
      branchId: map['branchId'] ?? '',
      branchName: map['branchName'] ?? '',
      address: map['address'] ?? '',
      contactName: map['contactName'] ?? '',
      contactPhone: map['contactPhone'] ?? '',
      deliveryVolume: map['deliveryVolume'] ?? 0,
      recyclableTypes: List<String>.from(map['recyclableTypes'] ?? []),
      deliverySchedule: List<int>.from(map['deliverySchedule'] ?? []),
    );
  }

  @override
  String toString() {
    return '''
TraderBranchModel {
  Branch ID: $branchId
  Branch Name: $branchName
  Address: $address
  Contact Name: $contactName
  Contact Phone: $contactPhone
  Delivery Volume: $deliveryVolume kg
  Recyclable Types: ${recyclableTypes.join(', ')}
  Delivery Schedule (Days): $deliverySchedule
  Delivery Days: ${getDeliveryDaysText()}
}''';
  }

  TraderBranchModel copyWith({
    String? branchId,
    String? branchName,
    String? address,
    String? contactName,
    String? contactPhone,
    int? deliveryVolume,
    List<String>? recyclableTypes,
    List<int>? deliverySchedule,
  }) {
    return TraderBranchModel(
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      address: address ?? this.address,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      deliveryVolume: deliveryVolume ?? this.deliveryVolume,
      recyclableTypes: recyclableTypes ?? this.recyclableTypes,
      deliverySchedule: deliverySchedule ?? this.deliverySchedule,
    );
  }

  // Helper method لتحويل shipmentDays لأسماء الأيام
  String getDeliveryDaysText() {
    const Map<int, String> dayNames = {
      0: 'الأحد',
      1: 'الإثنين',
      2: 'الثلاثاء',
      3: 'الأربعاء',
      4: 'الخميس',
      5: 'الجمعة',
      6: 'السبت',
    };

    if (deliverySchedule.isEmpty) return 'غير محدد';

    return deliverySchedule
        .map((day) => dayNames[day] ?? '')
        .where((day) => day.isNotEmpty)
        .join(', ');
  }
}
