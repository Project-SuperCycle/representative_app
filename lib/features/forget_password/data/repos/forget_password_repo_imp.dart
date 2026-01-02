import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/features/forget_password/data/model/reset_password_model.dart';
import 'package:supercycle/features/forget_password/data/model/verify_reset_otp_model.dart';
import 'forget_password_repo.dart';

class ForgetPasswordRepoImp implements ForgetPasswordRepo {
  final ApiServices apiServices;

  ForgetPasswordRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, String>> forgetPassword(String email) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.post(
          endPoint: ApiEndpoints.forgetPassword,
          data: {"email": email},
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'forget password',
    );
  }

  @override
  Future<Either<Failure, String>> verifyResetOtp(
    VerifyResetOtpModel verifyModel,
  ) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.post(
          endPoint: ApiEndpoints.verifyResetOtp,
          data: verifyModel.toJson(),
        );

        if (response['resetToken'] == null) {
          throw ServerFailure('Invalid response: Missing reset token', 422);
        }

        return response['resetToken'];
      },
      errorContext: 'verify reset otp',
    );
  }

  @override
  Future<Either<Failure, String>> resetPassword(ResetPasswordModel resetModel) {
    return ErrorHandler.handleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.post(
          endPoint: ApiEndpoints.resetPassword,
          data: resetModel.toJson(),
        );

        if (response['message'] == null) {
          throw ServerFailure('Invalid response: Missing message', 422);
        }

        return response['message'];
      },
      errorContext: 'reset password',
    );
  }
}
