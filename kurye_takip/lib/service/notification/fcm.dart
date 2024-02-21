// ignore_for_file: unused_import, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/helpers/get_local_user.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/service/api_service.dart';
import 'package:kurye_takip/service/notification/local.dart';

import '../firebase_options.dart';

class FirebaseNotificationService {
  late final FirebaseMessaging messaging;

  void settingsNotification() async {
    await messaging.requestPermission(alert: true, sound: true, badge: true);

    await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }

  void userSaveToken() {
    messaging.getToken().then(
      (value) async {
        FirebaseMessaging.instance.subscribeToTopic('global');
        //log("Token: $value", name: "FCM Token");
        bool login = await Helpers.isLoggedIn();
        if (login) {
          Map<String, dynamic> tokenMap = {
            "UserID": GetLocalUserInfo.getLocalUserID(),
            "Token": value,
          };
          await ApiService.SaveNotificationToken(tokenMap);
        }
      },
    );
  }

  void connectNotification() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    messaging = FirebaseMessaging.instance;

    settingsNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      RemoteNotification? remoteNotification = event.notification;
      AndroidNotification? androidNotification = event.notification?.android;

      log(event.data.toString(), name: "data");
      log("Foreground Notification Will Show", name: "FCM Messaging");

      if (remoteNotification != null && GetPlatform.isAndroid) {
        LocalNotifications.showNotification(
          title: event.notification!.title.toString(),
          body: event.notification!.body.toString(),
          payload: findAndroidPayload(event),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      var data = event.data;
      log(data['screen'].toString(), name: "Notification Screen");
      /*
      if (data['screen'].toString() == 'NewMessage') {
        Get.to(() => ChatView(roomID: data['parameter2']));
      } else if (data['screen'].toString() == 'NewOffer') {
        Get.to(() => MyAdDetailView(advertisementID: data['parameter1'], tabIndex: 1));
      } else if (data['screen'].toString() == 'NewOpportunity') {
        Get.to(() => OpportunityDetailView(id: data['parameter1']));
      }
      */
    });

    userSaveToken();
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    log("Handling a background message: ${message.messageId}", name: "Background Notification");
  }

  String findAndroidPayload(RemoteMessage message) {
    String result = "";

    var data = message.data;
    if (data['screen'].toString() == 'RentRequests') {
      result = "RentRequests";
    }

    /*else if (data['screen'].toString() == 'NewOffer') {
      result = "NewOffer-" + data['parameter1'].toString();
    } else if (data['screen'].toString() == 'NewOpportunity') {
      result = "NewOpportunity-" + data['parameter1'].toString();
    }
    */
    return result;
  }
}

void loginSaveToken() {
  FirebaseMessaging.instance.getToken().then((value) {
    FirebaseMessaging.instance.subscribeToTopic('global');
    //log("Token: $value", name: "FCM Token");
  });
}
