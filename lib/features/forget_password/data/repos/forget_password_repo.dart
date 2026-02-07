import 'package:dartz/dartz.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/features/forget_password/data/model/reset_password_model.dart';
import 'package:representative_app/features/forget_password/data/model/verify_reset_otp_model.dart';

abstract class ForgetPasswordRepo {
  Future<Either<Failure, String>> forgetPassword(String email);

  Future<Either<Failure, String>> verifyResetOtp(
    VerifyResetOtpModel verifyModel,
  );

  Future<Either<Failure, String>> resetPassword(ResetPasswordModel resetModel);
}
