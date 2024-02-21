// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/helpers/helper_functions.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/service/auth_service.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HelpFunctions.closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Şifremi Unuttum"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
              child: Form(
            key: controller.resetPasswordForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Girdiğiniz eposta adresine gelen epostadaki linkten şifrenizi değiştirebilirisiniz.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) => value!.isEmpty
                      ? "Boş bırakılamaz"
                      : !value.toString().isEmail
                          ? "Geçerli bir eposta adresi giriniz."
                          : null,
                  controller: controller.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Eposta Adresi",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                      fillColor: Colors.grey.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.email)),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 60.0)),
                    ),
                    onPressed: () async {
                      if (controller.resetPasswordForm.currentState!.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        GeneralResponse generalResponse = await controller.resetPassword();
                        bool isEmailSend = generalResponse.success;
                        Navigator.pop(context);
                        if (isEmailSend) {
                          Helpers.showSnackbar("Başarılı", "Eposta gönderildi.");
                        } else {
                          Helpers.showSnackbar("Başarısız", "Eposta gönderilemedi.");
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Eposta Gönder"),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}

class ForgotPasswordController extends GetxController {
  TextEditingController email = TextEditingController();
  final resetPasswordForm = GlobalKey<FormState>();

  Future<GeneralResponse> resetPassword() async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "Şifre sıfırlama talebi gönderilemedi");

    Map<String, dynamic> forgotPasswordMap = {"Mail": email.text};

    generalResponse = await AuthService.forgotPassword(forgotPasswordMap);
    return generalResponse;
  }
}
