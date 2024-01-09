import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/dashboard/dashboard.dart';
import 'package:kurye_takip/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  Future<Register> register(RegisterModel registerData) async {
    try {
      Register result = await _authService.register(registerData);
      return result;
    } catch (e) {
      print('Hata: $e');
      Get.snackbar('Hata', 'Kayıt başarısız oldu. Lütfen tekrar deneyin.');
      throw Exception(e);
    }
  }

  Future<Login> login(String email, String cyriptedPassword) async {
    try {
      Login result = await _authService.login(email, cyriptedPassword);
      //await saveUserData(result.user);
      print(result.user.code);
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
