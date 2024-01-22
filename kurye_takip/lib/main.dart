import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/pages/add_car/add_car.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/auth/register.dart';
import 'package:kurye_takip/pages/dashboard/dashboard.dart';
import 'package:kurye_takip/pages/gnav_bar/gnav_bar.dart';

Future<void> main() async {
  //Get.put(CarController());
  await GetStorage.init();

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
      ),
      //home: LoginPage(),renteker
      //GoogleNavBar(),
      //home: GoogleNavBar(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('tr')],
      locale: const Locale("tr"),
      //home: AddCarPage(),
      //home: TestAddCarView(),
      home: LoginPage(),
    );
  }
}
