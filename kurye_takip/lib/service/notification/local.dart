// ignore_for_file: file_names
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/pages/owner_notifications/owner_notifications.dart';

class LocalNotifications {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationsDetails(String body) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'Renteker Channel',
        'Renteker Bildirimleri',
        importance: Importance.max,
        channelDescription: "Renteker Bildirim Kanalıdır",
        playSound: true,
        enableVibration: true,
        styleInformation: BigTextStyleInformation(body),
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    final details = await _notifications.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      log(details.notificationResponse!.payload!, name: "Local Payload 2");
      //onNotifications.add(details.notificationResponse!.payload as String);
    }

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) async {
        log(payload.payload!, name: "Local Payload");
        String payload2 = payload.payload!;
        if (payload2 == 'RentRequests') {
          Get.to(() => OwnerNotificationsPage());
        }
      },
    );
  }

  static Future showNotification({int id = 0, String? title, String? body, String? payload}) async {
    _notifications.show(
      id,
      title,
      body,
      await _notificationsDetails(body!),
      payload: payload,
    );
  }
}
