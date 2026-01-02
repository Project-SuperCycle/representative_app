import 'package:dartz/dartz.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/features/sign_up/data/models/business_information_model.dart';
import 'package:supercycle/features/sign_up/data/models/otp_verification_model.dart';
import 'package:supercycle/features/sign_up/data/models/signup_credentials_model.dart';
import 'package:supercycle/features/sign_up/data/repos/signup_repo.dart';

class SignUpRepoImp implements SignUpRepo {
  final ApiServices apiServices;

  SignUpRepoImp({required this.apiServices});

  /// بدء عملية التسجيل
  @override
  Future<Either<Failure, String>> initiateSignup({
    required SignupCredentialsModel credentials,
  }) async {
    return await ErrorHandler.simpleApiCall<String>(
      apiCall: () async {
        final response = await apiServices.post(
          endPoint: ApiEndpoints.signup,
          data: credentials.toJson(),
        );
        return response['message'] as String;
      },
      errorContext: 'initiating signup',
      errorMessage: 'Failed to initiate signup. Please try again.',
      specificErrorMessages: {
        'email already exists': 'This email is already registered',
        'invalid email': 'Please enter a valid email address',
        'weak password': 'Password is too weak',
      },
    );
  }

  /// التحقق من رمز OTP
  @override
  Future<Either<Failure, String>> verifyOtp({
    required OtpVerificationModel credentials,
  }) async {
    return await ErrorHandler.handleApiResponse<String>(
      apiCall: () => apiServices.post(
        endPoint: ApiEndpoints.verifyOtp,
        data: credentials.toJson(),
      ),
      errorContext: 'verifying OTP',
      responseParser: (response) => response['message'] as String,
      customErrorChecks: (response) {
        // التحقق من وجود token
        if (response['token'] == null) {
          return ServerFailure('Invalid response: Missing token', 422);
        }
        return null;
      },
      onSuccess: (message, response) async {
        await StorageServices.storeData('token', response['token']);
      },
    );
  }

  /// إكمال عملية التسجيل
  @override
  Future<Either<Failure, String>> completeSignup({
    required BusinessInformationModel businessInfo,
  }) async {
    return await ErrorHandler.handleApiResponse<String>(
      apiCall: () => apiServices.post(
        endPoint: ApiEndpoints.completeSignup,
        data: businessInfo.toJson(),
      ),
      errorContext: 'completing signup',
      responseParser: (response) => response['message'] as String,
    );
  }
}
