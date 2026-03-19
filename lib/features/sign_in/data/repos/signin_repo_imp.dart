import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:representative_app/core/constants.dart';
import 'package:representative_app/core/errors/failures.dart';
import 'package:representative_app/core/helpers/error_handler.dart';
import 'package:representative_app/core/services/api_endpoints.dart';
import 'package:representative_app/core/services/api_services.dart';
import 'package:representative_app/core/services/auth_manager_services.dart';
import 'package:representative_app/core/services/notifications/push_notifications_service.dart';
import 'package:representative_app/core/services/storage_services.dart';
import 'package:representative_app/core/services/user_profile_services.dart';
import 'package:representative_app/features/sign_in/data/models/logined_user_model.dart';
import 'package:representative_app/features/sign_in/data/models/signin_credentials_model.dart';
import 'package:representative_app/features/sign_in/data/repos/signin_repo.dart';

class SignInRepoImp implements SignInRepo {
  /// تسجيل الدخول بالبريد الإلكتروني
  final ApiServices apiServices;
  final AuthManager _authManager = AuthManager();
  final Logger _logger = Logger();

  SignInRepoImp({required this.apiServices});

  /// تسجيل الدخول بالبريد الإلكتروني
  @override
  Future<Either<Failure, LoginedUserModel>> userSignIn({
    required SigninCredentialsModel credentials,
  }) async {
    return ErrorHandler.handleApiResponse<LoginedUserModel>(
      apiCall: () => apiServices.post(
        endPoint: ApiEndpoints.login,
        data: credentials.toJson(),
      ),
      errorContext: 'email login',
      responseParser: (response) {
        return LoginedUserModel.fromJson(response['data']);
      },
      customErrorChecks: (response) {
        final token = response['token'];

        if (token == null && response['Code'] == kNotVerified) {
          return ServerFailure.fromResponse(403, response);
        }

        if (token != null && response['Code'] == kProfileIncomplete) {
          return ServerFailure(response['message'], 200);
        }

        return null;
      },
      onSuccess: (user, response) async {
        await _saveUserData(user, response['token']);
        unawaited(_registerDeviceToServer());
      },
    );
  }

  /// حفظ بيانات المستخدم
  Future<void> _saveUserData(LoginedUserModel user, String token) async {
    if (user.role != "representative") return;

    await Future.wait([
      StorageServices.storeData('user', user.toJson()),
      StorageServices.storeData('token', token),
    ]);

    await UserProfileService.fetchAndStoreUserProfile();
    await _authManager.onLoginSuccess();
  }

  /// تسجيل الجهاز (آمن 100%)
  Future<void> _registerDeviceToServer() async {
    try {
      final canRegister = await PushNotificationsService.canRegisterDevice();
      if (!canRegister) {
        // ✅ Fix #3: log the reason instead of silently returning
        _logger.w(
          '⚠️ Device registration skipped: canRegisterDevice() = false',
        );
        return;
      }

      final fcmData = await PushNotificationsService.getStoredFCMData();
      if (fcmData == null) {
        _logger.w('⚠️ Device registration skipped: FCM data is null');
        return;
      }

      final token = fcmData['token'];
      final platform = fcmData['platform'];

      if (token == null || token.isEmpty || platform == null) {
        _logger.w(
          '⚠️ Device registration skipped: token or platform is missing',
        );
        return;
      }

      _logger.d('''
╔════════════════════════════════════════
║ Registering Device REPO
╠════════════════════════════════════════
║ Token: ${token.substring(0, token.length.clamp(0, 20))}...
║ Platform: $platform
║ App: trader
╚════════════════════════════════════════
''');

      await apiServices.post(
        endPoint: ApiEndpoints.registerDevice,
        data: {"token": token, "platform": platform, "app": "trader"},
      );
    } catch (e, stackTrace) {
      _logger.e(
        '⚠️ Device registration failed (non-critical)',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
