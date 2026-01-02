import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';
import 'package:supercycle/features/sign_in/data/models/signin_credentials_model.dart';

/// واجهة مستودع تسجيل الدخول
abstract class SignInRepo {
  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  Future<Either<Failure, LoginedUserModel>> userSignin({
    required SigninCredentialsModel credentials,
  });

  /// تسجيل الدخول عبر Google
  Future<Either<Failure, LoginedUserModel>> signInWithGoogle();

  /// تسجيل الدخول عبر Facebook
  Future<Either<Failure, LoginedUserModel>> signInWithFacebook();
}
