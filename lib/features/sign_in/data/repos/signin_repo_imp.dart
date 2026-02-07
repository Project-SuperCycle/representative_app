import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:representative_app/core/constants.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/core/helpers/error_handler.dart';
import 'package:representative_app/core/models/social_auth_request_model.dart';
import 'package:representative_app/core/models/social_auth_response_model.dart';
import 'package:representative_app/core/services/api_endpoints.dart';
import 'package:representative_app/core/services/api_services.dart';
import 'package:representative_app/core/services/auth_manager_services.dart';
import 'package:representative_app/core/services/social_auth_services.dart';
import 'package:representative_app/core/services/storage_services.dart';
import 'package:representative_app/core/services/user_profile_services.dart';
import 'package:representative_app/features/sign_in/data/models/logined_user_model.dart';
import 'package:representative_app/features/sign_in/data/models/signin_credentials_model.dart';
import 'package:representative_app/features/sign_in/data/repos/signin_repo.dart';

class SignInRepoImp implements SignInRepo {
  final ApiServices apiServices;
  final AuthManager _authManager = AuthManager();
  final Logger _logger = Logger();

  // Trader roles للتحقق
  static const Set<String> _traderRoles = {
    'trader_contracted',
    'trader_uncontracted',
  };

  SignInRepoImp({required this.apiServices});

  // ══════════════════════════════════════════════════════════
  // تسجيل الدخول بالبريد الإلكتروني
  // ══════════════════════════════════════════════════════════
  @override
  Future<Either<Failure, LoginedUserModel>> userSignin({
    required SigninCredentialsModel credentials,
  }) async {
    return await ErrorHandler.handleApiResponse<LoginedUserModel>(
      apiCall: () => apiServices.post(
        endPoint: ApiEndpoints.login,
        data: credentials.toJson(),
      ),
      errorContext: 'email login',
      responseParser: (response) => LoginedUserModel.fromJson(response['data']),
      customErrorChecks: (response) {
        final token = response['token'];
        final code = response['Code'];

        // عدم التحقق من البريد
        if (token == null && code == kNotVerified) {
          return ServerFailure.fromResponse(403, response);
        }

        // الملف غير مكتمل
        if (token != null && code == kProfileIncomplete) {
          return ServerFailure(response['message'], 200);
        }

        return null;
      },
      onSuccess: (user, response) async {
        await _saveUserData(user, response['token']);
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  // تسجيل الدخول بـ Google
  // ══════════════════════════════════════════════════════════
  @override
  Future<Either<Failure, LoginedUserModel>> signInWithGoogle() async {
    _logger.i('Starting Google Sign In');

    // الحصول على Google token
    final idTokenResult = await ErrorHandler.simpleApiCall<String>(
      apiCall: () => SocialAuthService.signInWithGoogle(),
      errorContext: 'Google authentication',
      specificErrorMessages: {
        'Google Sign In failed': 'تم إلغاء تسجيل الدخول بـ Google',
      },
      errorMessage: 'حدث خطأ أثناء المصادقة مع Google',
    );

    if (idTokenResult.isLeft()) {
      return idTokenResult.fold(
        (failure) => left(failure),
        (_) => left(ServerFailure('Unexpected error', 520)),
      );
    }

    final idToken = idTokenResult.getOrElse(() => '');

    // تسجيل الدخول بالـ backend
    return await ErrorHandler.handleApiResponse<LoginedUserModel>(
      apiCall: () => apiServices.post(
        endPoint: ApiEndpoints.socialLogin,
        data: {'idToken': idToken, 'provider': 'google'},
      ),
      errorContext: 'Google login',
      responseParser: (response) => LoginedUserModel.fromJson(response['data']),
      customErrorChecks: (response) =>
          ErrorHandler.validateResponseData(response, ['data', 'token']),
      onSuccess: (user, response) async {
        await _saveUserData(user, response['token']);
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  // التسجيل عبر Social Auth
  // ══════════════════════════════════════════════════════════
  @override
  Future<Either<Failure, SocialAuthResponseModel>> socialSignup({
    required SocialAuthRequestModel credentials,
  }) async {
    return await ErrorHandler.handleApiResponse<SocialAuthResponseModel>(
      apiCall: () => apiServices.post(
        endPoint: ApiEndpoints.socialLogin,
        data: credentials.toJson(),
      ),
      errorContext: 'Social signup',
      responseParser: (response) => _buildSocialAuthResponse(response),
      customErrorChecks: (response) => _validateSocialAuthResponse(response),
      onSuccess: (socialAuth, response) async {
        await _handleSocialAuthSuccess(socialAuth, response);
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  // Helper Methods
  // ══════════════════════════════════════════════════════════

  /// بناء Social Auth Response حسب الـ status
  SocialAuthResponseModel _buildSocialAuthResponse(
    Map<String, dynamic> response,
  ) {
    final status = response['status'];
    final message = response['message'];
    final token = response['token'];

    if (status == 201) {
      // حساب جديد - يحتاج استكمال بيانات
      return SocialAuthResponseModel.fromJson({
        'status': status,
        'message': message,
        'token': token,
      });
    } else if (status == 200) {
      // حساب موجود - تسجيل دخول مباشر
      return SocialAuthResponseModel.fromJson({
        'status': status,
        'message': message,
        'token': token,
        'user': response['data'],
      });
    } else {
      _logger.w('⚠️ Unexpected status: $status');
      return SocialAuthResponseModel.fromJson({
        'status': status,
        'message': message,
      });
    }
  }

  /// التحقق من صحة Social Auth Response
  Failure? _validateSocialAuthResponse(Map<String, dynamic> response) {
    final status = response['status'];

    if (status == null) {
      _logger.e('❌ Missing status in response');
      return ServerFailure('Invalid response: Missing status', 422);
    }

    // للحالات الناجحة (200 أو 201) التحقق من token
    if (status == 200 || status == 201) {
      final token = response['token']?.toString();
      if (token == null || token.isEmpty) {
        _logger.e('❌ Missing token for successful status');
        return ServerFailure('Invalid response: Missing token', 422);
      }

      // للحالة 200 التحقق من user data
      if (status == 200 && response['data'] == null) {
        _logger.e('❌ Missing user data for existing account');
        return ServerFailure('Invalid response: Missing user data', 422);
      }
    }

    return null;
  }

  /// معالجة نجاح Social Auth
  Future<void> _handleSocialAuthSuccess(
    SocialAuthResponseModel socialAuth,
    Map<String, dynamic> response,
  ) async {
    final status = response['status'];

    if (status == 201) {
      // حساب جديد - حفظ token فقط
      await StorageServices.storeData('token', socialAuth.token);
    } else if (status == 200) {
      // حساب موجود - حفظ كل البيانات
      if (socialAuth.user != null) {
        await _saveUserData(socialAuth.user!, socialAuth.token!);
      } else {
        _logger.w('⚠️ User data is null, saving token only');
        await StorageServices.storeData('token', socialAuth.token);
      }
    } else {
      _logger.w('⚠️ Unexpected status, no data saved: $status');
    }
  }

  /// حفظ بيانات المستخدم
  Future<void> _saveUserData(LoginedUserModel user, String token) async {
    // منع حفظ بيانات الـ traders
    if (_traderRoles.contains(user.role)) {
      _logger.w('⚠️ Trader role detected, skipping save');
      return;
    }

    // حفظ البيانات
    await Future.wait([
      StorageServices.storeData('user', user.toJson()),
      StorageServices.storeData('token', token),
    ]);

    await UserProfileService.fetchAndStoreUserProfile();
    await _authManager.onLoginSuccess();
  }
}
