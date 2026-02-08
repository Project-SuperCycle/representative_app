import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

StreamController<NotificationResponse> notificationStreamController =
    StreamController<NotificationResponse>();

/// 🔥 MUST be top-level + annotated
@pragma('vm:entry-point')
void onTapNotification(NotificationResponse notificationResponse) {
  notificationStreamController.add(notificationResponse);
  Logger().w("Background notification tapped: ${notificationResponse.payload}");
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

  /// 🔹 Show a basic notification
  static void showBasicNotification({required RemoteMessage message}) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id_1",
        "basic_notifications",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: details,
    );
  }

  static void showRepeatedNotification() async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id_2",
        "basic_notifications",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      id: 1,
      title: "REPEATED NOTI",
      body: "NOTI BODY",
      repeatInterval: RepeatInterval.everyMinute,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      notificationDetails: details,
    );
  }

  static void cancelNotification({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }
}
