import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:representative_app/core/utils/app_assets.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

StreamController<NotificationResponse> notificationStreamController =
    StreamController<NotificationResponse>.broadcast();

/// 🔥 MUST be top-level + annotated
@pragma('vm:entry-point')
void onTapNotification(NotificationResponse notificationResponse) {
  notificationStreamController.add(notificationResponse);
  Logger().w("Notification tapped: ${notificationResponse.payload}");
}

class LocalNotificationsService {
  /// 🔹 Initialization
  static Future<void> init() async {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveBackgroundNotificationResponse: onTapNotification,
      onDidReceiveNotificationResponse: onTapNotification,
    );
  }

  /// 🔹 Show a basic notification with payload
  static void showBasicNotification({required RemoteMessage message}) async {
    // Extract notification data
    Map<String, dynamic> notificationData = {
      'relatedEntity': message.data['relatedEntity'] ?? '',
      'relatedEntityId': message.data['relatedEntityId'] ?? '',
      'type': message.data['type'] ?? '',
      ...message.data, // Include all other data
    };

    // Convert to JSON string for payload
    String payload = jsonEncode(notificationData);

    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id_1",
        "basic_notifications",
        importance: Importance.max,
        priority: Priority.high,
        icon: AppAssets.logoIcon,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      id: message.hashCode,
      // Unique ID for each notification
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: details,
      payload: payload, // ✅ Pass the payload here
    );
  }

  /// 🔹 Parse notification payload
  static Map<String, dynamic>? parsePayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      Logger().w("No payload found in notification");
      return null;
    }

    try {
      Map<String, dynamic> data = jsonDecode(payload);

      return data;
    } catch (e) {
      Logger().e("Error parsing notification payload: $e");
      return null;
    }
  }

  static String _formatDataPayload(Map<String, dynamic> data) {
    if (data.isEmpty) return '║ (Empty)';

    StringBuffer buffer = StringBuffer();
    data.forEach((key, value) {
      buffer.writeln('║ $key: $value');
    });
    return buffer.toString().trimRight();
  }

  static void cancelNotification({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }
}
