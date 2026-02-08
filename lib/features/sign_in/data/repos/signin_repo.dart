import 'package:dartz/dartz.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/features/sign_in/data/models/logined_user_model.dart';
import 'package:representative_app/features/sign_in/data/models/signin_credentials_model.dart';

/// واجهة مستودع تسجيل الدخول
abstract class SignInRepo {
  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  Future<Either<Failure, LoginedUserModel>> userSignIn({
    required SigninCredentialsModel credentials,
  });
}
