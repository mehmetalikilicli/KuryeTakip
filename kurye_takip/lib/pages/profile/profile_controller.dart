// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/model/register.dart';
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

  User user = User();
  RegisterModel registerModel = RegisterModel();

  void getLocalUser() {
    final box = GetStorage();
    final userData = box.read('user_data');
    if (userData != null) {
      user = User.fromJson(userData);
      profileName.text = user.name ?? "";
      profileSurname.text = user.surname ?? "";
      profileEmail.text = user.email ?? "";
      profilePhone.text = user.phone ?? "";
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
}
