import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/dashboard/dashboard.dart';
import 'package:kurye_takip/pages/profile/profile.dart';

void main() {
  //Get.put(CarController());
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
      //home: LoginPage(),
      home: ProfilePage(),
    );
  }
}
