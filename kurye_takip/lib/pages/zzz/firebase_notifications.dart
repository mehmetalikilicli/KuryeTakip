/*
// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, file_names

import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kurye_takip/helpers/get_local_user_id.dart';
import 'local_notification.dart';

class FirebaseNotificationService {
  late final FirebaseMessaging messaging;

  void settingsNotification() async {
    await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  void connectNotification() async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    messaging.setForegroundNotificationPresentationOptions(badge: true, sound: true, alert: true);

    settingsNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      log("Bildirim Geldi");
      NotificationsApi.showNotification(
        title: event.notification!.title.toString(),
        body: event.notification!.body.toString(),
      );
    });

    messaging.getToken().then((value) {
      log("Token: $value", name: "FCM Token");
      int userid = getLocalUserID();
      //if (userid > 0) AccountApi.saveToken(jsonEncode({"User": AppStorage.encodedUserID(), "Token": value}));
      FirebaseMessaging.instance.subscribeToTopic('global');
    });
  }

  static Future<void> backgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log("Bildirim Geldi Background");
    print("Handling a Background Message: ${message.messageId}");
  }
}
*/