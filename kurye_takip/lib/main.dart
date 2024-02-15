// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/pages/rent_notifications/rent_notification.dart';
import 'package:kurye_takip/service/firebase_options.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/dashboard/dashboard.dart';
import 'package:kurye_takip/pages/zzz/home.dart';
import 'package:kurye_takip/pages/zzz/firebase_api.dart';
import 'package:kurye_takip/service/notification/fcm.dart';

import 'service/notification/local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(FirebaseNotificationService.firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Renteker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('tr')],
      locale: const Locale("tr"),
      home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //log("Login waiting");
            return Container();
          } else {
            if (snapshot.hasError) {
              //log("Can't Logged In ${snapshot.error}");
              return Container();
            } else {
              final isLoggedIn = snapshot.data!;
              return isLoggedIn ? const Dashboard() : LoginPage();
            }
          }
        },
      ),
    );
  }

  Future<bool> isLoggedIn() async {
    final box = GetStorage();
    final userData = box.read('user_data');
    if (userData != null) {
      LocalNotifications.init();
      FirebaseNotificationService().connectNotification();
      setupInteractedMessage();
      return true;
    } else {
      return false;
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage2);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    if (message.data['screen'] == 'RentRequests') {
      Get.to(() => RentNotificationPage());
    }
  }

  Future<void> _handleMessage2(RemoteMessage message) async {
    if (message.data['screen'] == 'RentRequests') {
      Get.to(() => RentNotificationPage());
    }
  }
}
