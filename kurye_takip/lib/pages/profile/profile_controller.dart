// ignore_for_file: prefer_final_fields, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kurye_takip/helpers/get_local_user.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/service/api_service.dart';
import 'package:kurye_takip/service/profile_service.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    getLocalUser();
    super.onInit();
  }

  ProfileService _profileService = ProfileService();

  RxBool isTextEditorsEnabled = false.obs;

  final profileFormKey = GlobalKey<FormState>();

  TextEditingController profileName = TextEditingController();
  TextEditingController profileSurname = TextEditingController();
  TextEditingController profileEmail = TextEditingController();
  TextEditingController profilePhone = TextEditingController();

  int isVehicleOwner = 0;
  int isUserLogedIn = 0;

  User user = User();
  RegisterModel registerModel = RegisterModel();

  void getLocalUser() {
    final box = GetStorage();
    final userData = box.read('user_data');
    if (userData != null) {
      isUserLogedIn = 1;
      user = User.fromJson(userData);
      profileName.text = user.name ?? "";
      profileSurname.text = user.surname ?? "";
      profileEmail.text = user.email ?? "";
      profilePhone.text = user.phone ?? "";
      isVehicleOwner = user.isVehicleOwner ?? -1;
    }
  }

  void changeEditStatus() {
    isTextEditorsEnabled.value = !isTextEditorsEnabled.value;
  }

  Future editUser(RegisterModel registerModel) async {
    try {
      RegisterResponse result = await _profileService.editUser(registerModel);
      return result;
    } catch (e) {
      Get.snackbar('Hata', 'Güncelleme başarısız oldu. Lütfen tekrar deneyin.');
      throw Exception(e);
    }
  }

  Future<void> Logout() async {
    try {
      Map<String, dynamic> tokenMap = {
        "UserID": GetLocalUserInfo.getLocalUserID(),
        "Token": "",
      };
      GeneralResponse generalResponse = await ApiService.SaveNotificationToken(tokenMap);
      log(generalResponse.message, name: "logout generalresponse message");
      final box = GetStorage();
      box.remove('user_data');

      Get.offAll(const LoginPage());
    } catch (ex) {
      log("Cant logout ${ex}");
    }
  }
}
