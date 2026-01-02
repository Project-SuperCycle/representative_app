class LoginedUserModel {
  final String? bussinessName;
  final String? rawBusinessType;
  final String? bussinessAdress;
  final String? doshMangerName;
  final String? doshMangerPhone;
  final String? email;
  final String? role;
  final String? phone;
  final String? displayName;
  final bool? isEcoParticipant;

  LoginedUserModel({
    this.bussinessName,
    this.rawBusinessType,
    this.bussinessAdress,
    this.doshMangerName,
    this.doshMangerPhone,
    this.email,
    this.role,
    this.phone,
    this.displayName,
    this.isEcoParticipant,
  });

  // fromJson constructor
  factory LoginedUserModel.fromJson(Map<String, dynamic> json) {
    return LoginedUserModel(
      bussinessName: (json['profile'] == null)
          ? null
          : json['profile']['bussinessName'],
      rawBusinessType: (json['profile'] == null)
          ? null
          : json['profile']['rawBusinessType'],
      bussinessAdress: (json['profile'] == null)
          ? null
          : json['profile']['bussinessAdress'],
      doshMangerName: (json['profile'] == null)
          ? null
          : json['profile']['doshMangerName'],
      doshMangerPhone: (json['profile'] == null)
          ? null
          : json['profile']['doshMangerPhone'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      displayName: json['displayName'],
      isEcoParticipant: json['isEcoParticipant'],
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
      'email': email,
      'role': role,
      'phone': phone,
      'displayName': displayName,
      'isEcoParticipant': isEcoParticipant,
    };
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'LoginedUserModel(bussinessName: $bussinessName, rawBusinessType: $rawBusinessType, bussinessAdress: $bussinessAdress, doshMangerName: $doshMangerName, doshMangerPhone: $doshMangerPhone, email: $email, role: $role, phone: $phone, displayName: $displayName)';
  }

  // Optional: copyWith method for creating modified copies
  LoginedUserModel copyWith({
    String? bussinessName,
    String? rawBusinessType,
    String? bussinessAdress,
    String? doshMangerName,
    String? doshMangerPhone,
    String? email,
    String? role,
    String? phone,
    String? displayName,
    bool? isEcoParticipant,
  }) {
    return LoginedUserModel(
      bussinessName: bussinessName ?? this.bussinessName,
      rawBusinessType: rawBusinessType ?? this.rawBusinessType,
      bussinessAdress: bussinessAdress ?? this.bussinessAdress,
      doshMangerName: doshMangerName ?? this.doshMangerName,
      doshMangerPhone: doshMangerPhone ?? this.doshMangerPhone,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      displayName: displayName ?? this.displayName,
      isEcoParticipant: isEcoParticipant ?? this.isEcoParticipant,
    );
  }
}
