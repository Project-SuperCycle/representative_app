class OtpVerificationModel {
  final String email;
  final String otp;

  OtpVerificationModel({
    required this.email,
    required this.otp,
  });

  // fromJson constructor
  factory OtpVerificationModel.fromJson(Map<String, dynamic> json) {
    return OtpVerificationModel(
      email: json['email'] as String,
      otp: json['otp'] as String,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'OtpVerificationModel(email: $email, otp: $otp)';
  }

  // Optional: copyWith method for creating modified copies
  OtpVerificationModel copyWith({
    String? email,
    String? otp,
  }) {
    return OtpVerificationModel(
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }
}
