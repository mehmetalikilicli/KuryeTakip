/*
// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  //static final onNotifications = BehaviorSubject<String>();

  static Future _notificationsDetails(String body) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'Renteker_SA',
        'Renteker',
        importance: Importance.max,
        channelDescription: "Charge Cloud Bildirim Kanalı",
        playSound: true,
        enableVibration: false,
        styleInformation: BigTextStyleInformation(body),
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/pakeat');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      //onNotifications.add(details.notificationResponse!.payload);
    }

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) async {
        log(payload.payload!, name: "localNotification payload");
        //onNotifications.add(payload);
      },
    );
  }

  static void showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.UTC),
        await _notificationsDetails(body!),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  static void showDayNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.UTC),
        await _notificationsDetails(body!),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationsDetails(body!),
        payload: payload,
      );
}
*/