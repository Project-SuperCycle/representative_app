import 'package:equatable/equatable.dart';

class ResetPasswordModel extends Equatable {
  const ResetPasswordModel({required this.resetToken, this.newPassword});

  final String? resetToken;
  final String? newPassword;

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      resetToken: json["resetToken"],
      newPassword: json["newPassword"],
    );
  }

  Map<String, dynamic> toJson() => {
    "resetToken": resetToken,
    "newPassword": newPassword,
  };

  @override
  List<Object?> get props => [resetToken, newPassword];
}
