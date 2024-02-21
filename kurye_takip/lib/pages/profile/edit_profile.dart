import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/helpers/helper_functions.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/service/auth_service.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profili Düzenle"),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        shadowColor: Colors.black,
      ),
      body: FutureBuilder(
        future: controller.getLocalUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return SafeArea(
            child: Column(
              children: [
                SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                        currentFocus.focusedChild!.unfocus();
                      }
                    },
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () => HelpFunctions.closeKeyboard(),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: controller.name,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  label: Text("İsim"),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                                ),
                                validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.surname,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  label: Text("Soyisim"),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.phone,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  label: Text("Telefon"),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(11),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  label: Text("Eposta"),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                validator: (value) => value!.isEmpty
                                    ? "Boş bırakılamaz"
                                    : !value.toString().isEmail
                                        ? "Geçerli bir mail adresi giriniz."
                                        : null,
                              ),
                              const SizedBox(height: 8),
                              /*Obx(
                                () => TextFormField(
                                    obscureText: controller.passwordHide.isTrue,
                                    controller: controller.password1,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      label: const Text("Şifre"),
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.password, color: AppColors.primaryColor),
                                      suffixIcon: GestureDetector(
                                        onTap: () => controller.passwordHide.toggle(),
                                        child: Icon(controller.passwordHide.isTrue ? Icons.visibility : Icons.visibility_off),
                                      ),
                                    ),
                                    validator: (value) => value!.isEmpty
                                        ? "Boş bırakılamaz"
                                        : value.trim() != controller.password2.text.trim()
                                            ? "Şifreler uyuşmuyor"
                                            : value.trim().length <= 6
                                                ? "Şifre en az 6 karakter olmalı"
                                                : null),
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => TextFormField(
                                    obscureText: controller.password2Hide.isTrue,
                                    controller: controller.password2,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      label: const Text("Şifre tekrar"),
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.password, color: AppColors.primaryColor),
                                      suffixIcon: GestureDetector(
                                          onTap: () => controller.password2Hide.toggle(),
                                          child: Icon(controller.password2Hide.isTrue ? Icons.visibility : Icons.visibility_off)),
                                    ),
                                    validator: (value) => value!.isEmpty
                                        ? "Boş bırakılamaz"
                                        : value.trim() != controller.password1.text.trim()
                                            ? "Şifreler uyuşmuyor"
                                            : value.trim().length <= 6
                                                ? "Şifre en az 6 karakter olmalı"
                                                : null),
                              ),*/
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MaterialButton(
                                      color: AppColors.primaryColor,
                                      minWidth: Get.width / 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      onPressed: () async {
                                        if (controller.formKey.currentState!.validate()) {
                                          GeneralResponse generalResponse = await controller.editProfile();
                                          try {
                                            if (generalResponse.success) {
                                              // ignore: use_build_context_synchronously
                                              CustomDialog.showMessage(
                                                  context: context, title: "Başarılı", message: "Bilgileriniz güncellendi", onPositiveButtonPressed: () {});
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              CustomDialog.showMessage(
                                                  context: context, title: "Hata", message: "Bilgileriniz güncellenemedi", onPositiveButtonPressed: () {});
                                            }
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                      },
                                      child: const Text(
                                        "Kaydet",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();

  RxBool passwordHide = true.obs, password2Hide = true.obs;

  User user = User();

  Future<void> getLocalUser() async {
    final box = GetStorage();
    final userData = await box.read('user_data');
    if (userData != null) {
      user = User.fromJson(userData);
      name.text = user.name ?? "";
      surname.text = user.surname ?? "";
      phone.text = user.phone ?? "";
      email.text = user.email ?? "";
    }
  }

  Future<GeneralResponse> editProfile() async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");

    Map<String, dynamic> editProfileMap = {
      "UserID": Helpers.encryption(getLocalUser().toString()),
      "Name": name.text,
      "Surname": surname.text,
      "Phone": phone.text,
      "Email": email.text,
    };
    log(Helpers.encryption(getLocalUser().toString()));

    generalResponse = await AuthService.editProfile(editProfileMap);

    return generalResponse;
  }
}
