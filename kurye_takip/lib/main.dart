import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/controllers/car_controller.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/auth/register.dart';
import 'package:kurye_takip/pages/map/map_view.dart';
import 'package:kurye_takip/pages/types_page/types_view.dart';

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
      //home: const TestView(),
      home: RegisterPage(),
    );
  }
}
