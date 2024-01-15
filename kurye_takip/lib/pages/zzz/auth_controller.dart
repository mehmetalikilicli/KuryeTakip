/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/dashboard/dashboard.dart';
import 'package:kurye_takip/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final markers = RxSet<Marker>();

  var selectedCity = 'Izmir'.obs;
  var selectedDistrict = 'Bornova'.obs;

  RxInt isDrivingLicenseFrontImageTaken = 0.obs;
  RxInt isDrivingLicenseBackImageTaken = 0.obs;
  RxInt isLocationTaken = 0.obs;

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final rentRegisterFormKey = GlobalKey<FormState>();

  //Login TextEditingControllers
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  //Register TextEditingControllers
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  TextEditingController drivingLicenseNumber = TextEditingController();
  TextEditingController drivingLicenseDate = TextEditingController();

  TextEditingController rentNameController = TextEditingController();
  TextEditingController rentSurnameController = TextEditingController();
  TextEditingController rentPhoneController = TextEditingController();
  TextEditingController rentEmailController = TextEditingController();
  TextEditingController rentPasswordController = TextEditingController();
  TextEditingController rentPassword2Controller = TextEditingController();

  RegisterModel registerModel = RegisterModel();

  void selectLocation() {}

  void selectCity(String city) {
    selectedCity.value = city;
    // İlk şehir değiştirildiğinde ilçeleri sıfırla
    selectedDistrict.value = '';
  }

  void selectDistrict(String district) {
    selectedDistrict.value = district;
  }

  List<String> getDistricts(String city) {
    // Şehire göre ilçeleri getir
    switch (city) {
      case 'Istanbul':
        return ['Besiktas', 'Kadikoy', 'Sisli'];
      case 'Ankara':
        return ['Cankaya', 'Kecioren', 'Mamak'];
      case 'Izmir':
        return ['Bornova', 'Konak', 'Cigli'];
      case 'Bursa':
        return ['Osmangazi', 'Nilufer', 'Yildirim'];
      default:
        return [];
    }
  }

  Future<RegisterResponse> register() async {
    try {
      RegisterResponse result = await _authService.register(registerModel);
      return result;
    } catch (e) {
      print('Hata: $e');
      Get.snackbar('Hata', 'Kayıt başarısız oldu. Lütfen tekrar deneyin.');
      throw Exception(e);
    }
  }

  Future<LoginResponse> login(String email, String cyriptedPassword) async {
    try {
      LoginResponse result = await _authService.login(email, cyriptedPassword);
      //await saveUserData(result.user);
      //print(result.user.code);
      return result;
    } catch (e) {
      print('Hata: $e');
      Get.snackbar('Hata', 'Giriş başarısız oldu. Lütfen tekrar deneyin.');
      throw Exception(e);
    }
  }

  Future<void> saveUserData(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert User object to JSON string
    String userJson = json.encode(user.toJson());

    // Save the JSON string to SharedPreferences
    await prefs.setString('user_data', userJson);
  }
}
*/