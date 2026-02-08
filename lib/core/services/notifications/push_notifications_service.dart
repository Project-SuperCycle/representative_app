import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:representative_app/core/services/notifications/local_notifications_service.dart';
import 'package:representative_app/core/services/storage_services.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PushNotificationsService {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final Logger _logger = Logger();

  static Future<void> init() async {
    try {
      final settings = await messaging.requestPermission();
      final authStatus = settings.authorizationStatus;

      final token = await messaging.getToken();
      await _saveDeviceTokenData(token: token, authStatus: authStatus);

      messaging.onTokenRefresh.listen((newToken) async {
        await _saveDeviceTokenData(token: newToken, authStatus: authStatus);
      });

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen((message) {
        LocalNotificationsService.showBasicNotification(message: message);
      });
    } catch (e, stackTrace) {
      _logger.e(
        'Push notification init failed',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> _saveDeviceTokenData({
    required String? token,
    required AuthorizationStatus authStatus,
  }) async {
    if (token == null || token.isEmpty) return;

    final bool isAuthorized = authStatus == AuthorizationStatus.authorized;
    final String platform = _getPlatform();

    await StorageServices.storeData("fcm_token", token);
    await StorageServices.storeData("fcm_platform", platform);
    await StorageServices.storeData("fcm_auth_status", isAuthorized);

    _logger.i('''
╔════════════════════════════════════════
║ FCM Data Saved
╠════════════════════════════════════════
║ Token: ${token.substring(0, token.length.clamp(0, 20))}...
║ Platform: $platform
║ Authorized: $isAuthorized
╚════════════════════════════════════════
''');
  }

  static String _getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  static Future<Map<String, String>?> getStoredFCMData() async {
    final String? token =
        await StorageServices.readData("fcm_token") as String?;
    final String? platform =
        await StorageServices.readData("fcm_platform") as String?;
    final bool? authStatus =
        await StorageServices.readData("fcm_auth_status") as bool?;

    if (token == null || platform == null || authStatus != true) {
      return null;
    }

    return {'token': token, 'platform': platform};
  }

  static Future<bool> canRegisterDevice() async {
    final bool? authStatus =
        await StorageServices.readData("fcm_auth_status") as bool?;
    return authStatus == true;
  }
}
