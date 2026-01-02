import 'package:dartz/dartz.dart';
import 'package:supercycle/core/constants.dart';
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/helpers/error_handler.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/core/services/auth_manager_services.dart';
import 'package:supercycle/core/services/social_auth_services.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/services/user_profile_services.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';
import 'package:supercycle/features/sign_in/data/models/signin_credentials_model.dart';
import 'package:supercycle/features/sign_in/data/repos/signin_repo.dart';

class SignInRepoImp implements SignInRepo {
  final ApiServices apiServices;
  final AuthManager _authManager = AuthManager();

  SignInRepoImp({required this.apiServices});

  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
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
      responseParser: (response) {
        var data = response['data'];
        return LoginedUserModel.fromJson(data);
      },
      customErrorChecks: (response) {
        var token = response['token'];

        // التحقق من حالة عدم التحقق من البريد
        if (token == null && response['Code'] == kNotVerified) {
          return ServerFailure.fromResponse(403, response);
        }

        // التحقق من حالة الملف غير المكتمل
        if (token != null && response['Code'] == kProfileIncomplete) {
          return ServerFailure(response['message'], 200);
        }

        return null;
      },
      onSuccess: (loginUser, response) async {
        await _saveUserData(loginUser, response['token']);
      },
    );
  }

  /// تسجيل الدخول عبر Google
  @override
  Future<Either<Failure, LoginedUserModel>> signInWithGoogle() async {
    // 1. الحصول على access token من Google
    final accessTokenResult = await ErrorHandler.simpleApiCall<String>(
      apiCall: () => SocialAuthService.signInWithGoogle(),
      errorContext: 'Google authentication',
      specificErrorMessages: {
        'Google Sign In failed': 'تم إلغاء تسجيل الدخول بـ Google',
      },
      errorMessage: 'حدث خطأ أثناء المصادقة مع Google',
    );

    // إذا فشل الحصول على token من Google
    if (accessTokenResult.isLeft()) {
      return accessTokenResult.fold(
        (failure) => left(failure),
        (_) => left(ServerFailure('Unexpected error', 520)),
      );
    }

    // استخراج الـ token
    final accessToken = accessTokenResult.getOrElse(() => '');

    // 2. إرسال الـ token للـ backend
    return await ErrorHandler.handleApiResponse<LoginedUserModel>(
      apiCall: () => apiServices.post(
        endPoint: ApiEndpoints.socialLogin,
        data: {'accessToken': accessToken},
      ),
      errorContext: 'Google login',
      responseParser: (response) {
        var data = response['data'];
        return LoginedUserModel.fromJson(data);
      },
      customErrorChecks: (response) {
        // التحقق من البيانات الأساسية
        return ErrorHandler.validateResponseData(response, ['data', 'token']);
      },
      onSuccess: (loginUser, response) async {
        await _saveUserData(loginUser, response['token']);
      },
    );
  }

  /// تسجيل الدخول عبر Facebook
  @override
  Future<Either<Failure, LoginedUserModel>> signInWithFacebook() async {
    // 1. الحصول على access token من Facebook
    final accessTokenResult = await ErrorHandler.simpleApiCall<String>(
      apiCall: () => SocialAuthService.signInWithFacebook(),
      errorContext: 'Facebook authentication',
      errorMessage: 'حدث خطأ أثناء المصادقة مع Facebook',
    );

    // إذا فشل الحصول على token من Facebook
    if (accessTokenResult.isLeft()) {
      return accessTokenResult.fold(
        (failure) => left(failure),
        (_) => left(ServerFailure('Unexpected error', 520)),
      );
    }

    // استخراج الـ token
    final accessToken = accessTokenResult.getOrElse(() => '');

    // 2. إرسال الـ token للـ backend
    return await ErrorHandler.handleApiResponse<LoginedUserModel>(
      apiCall: () => apiServices.post(
        endPoint: ApiEndpoints.socialLogin,
        data: {'accessToken': accessToken},
      ),
      errorContext: 'Facebook login',
      responseParser: (response) {
        var data = response['data'];
        return LoginedUserModel.fromJson(data);
      },
      customErrorChecks: (response) {
        // التحقق من البيانات الأساسية
        return ErrorHandler.validateResponseData(response, ['data', 'token']);
      },
      onSuccess: (loginUser, response) async {
        await _saveUserData(loginUser, response['token']);
      },
    );
  }

  /// حفظ بيانات المستخدم وتحديث حالة المصادقة
  Future<void> _saveUserData(LoginedUserModel user, String token) async {
    // 1. حفظ في Storage
    await StorageServices.storeData('user', user.toJson());
    await StorageServices.storeData('token', token);
    await UserProfileService.fetchAndStoreUserProfile();

    // 2. تحديث حالة المصادقة في AuthManager
    await _authManager.onLoginSuccess();
  }
}
