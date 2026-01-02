import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';

abstract class SignInState {}

/// الحالة الأولية
class SignInInitial extends SignInState {}

/// حالة التحميل (جاري تسجيل الدخول)
class SignInLoading extends SignInState {}

/// حالة النجاح
class SignInSuccess extends SignInState {
  final LoginedUserModel user;

  SignInSuccess({required this.user});
}

/// حالة الفشل
class SignInFailure extends SignInState {
  final String message;
  final int statusCode;

  SignInFailure({required this.message, required this.statusCode});
}
