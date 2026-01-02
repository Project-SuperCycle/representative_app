import 'package:dartz/dartz.dart' show Either;
import 'package:supercycle/core/errors/failures.dart' show Failure;
import 'package:supercycle/features/sign_up/data/models/business_information_model.dart'
    show BusinessInformationModel;
import 'package:supercycle/features/sign_up/data/models/otp_verification_model.dart'
    show OtpVerificationModel;
import 'package:supercycle/features/sign_up/data/models/signup_credentials_model.dart'
    show SignupCredentialsModel;

abstract class SignUpRepo {
  Future<Either<Failure, String>> initiateSignup({
    required SignupCredentialsModel credentials,
  });

  Future<Either<Failure, String>> verifyOtp({
    required OtpVerificationModel credentials,
  });

  Future<Either<Failure, String>> completeSignup({
    required BusinessInformationModel businessInfo,
  });
}
