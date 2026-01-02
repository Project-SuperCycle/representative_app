import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';

class SocialAuthResponseModel {
  final int status;
  final String? token;
  final String? message;
  final LoginedUserModel? user;

  const SocialAuthResponseModel({
    required this.status,
    this.token,
    this.message,
    this.user,
  });

  factory SocialAuthResponseModel.fromJson(Map<String, dynamic> json) {
    return SocialAuthResponseModel(
      status: json['status'] as int,
      token: json['token'] ?? '',
      message: json['message'] ?? '',
      user: json['user'] != null
          ? LoginedUserModel.fromJson(json['user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'token': token, 'message': message, 'user': user};
  }

  SocialAuthResponseModel copyWith({
    int? status,
    String? token,
    String? message,
    LoginedUserModel? user,
  }) {
    return SocialAuthResponseModel(
      status: status ?? this.status,
      token: token ?? this.token,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'SocialAuthResponseModel(status: $status, token: $token, message: $message, user: $user)';
  }
}
