import 'package:equatable/equatable.dart';

class VerifyResetOtpModel extends Equatable {
  const VerifyResetOtpModel({required this.email, this.otp});

  final String? email;
  final String? otp;

  factory VerifyResetOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyResetOtpModel(email: json["email"], otp: json["otp"]);
  }

  Map<String, dynamic> toJson() => {"email": email, "otp": otp};

  @override
  List<Object?> get props => [email, otp];
}
