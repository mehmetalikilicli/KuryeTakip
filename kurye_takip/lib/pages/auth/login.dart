// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/helpers/helper_functions.dart';
import 'package:kurye_takip/pages/auth/authentication.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/pages/auth/forgot_password.dart';
import 'package:kurye_takip/pages/auth/register.dart';
import 'package:kurye_takip/pages/dashboard/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController authController = Get.put(LoginController());

  @override
  void initState() {
    authController.loginEmailController.text = "";
    authController.loginPasswordController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HelpFunctions.closeKeyboard(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: authController.loginFormKey,
              child: Column(
                children: [
                  const ImageAndText(),
                  const EmailAndPassword(),
                  LoginAndRegisterButton(authController: authController),
                  //LoginWithGoogleAndApple(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageAndText extends StatelessWidget {
  const ImageAndText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 150,
            width: Get.width * 0.9,
            child: Image.asset(
              "assets/logo/logo_dark.png",
              fit: BoxFit.cover,
              width: Get.width,
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text("Giriş Yap", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class LoginWithGoogleAndApple extends StatelessWidget {
  const LoginWithGoogleAndApple({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Text(
          "Google yada Apple ile Giriş Yap",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                "assets/pngs/google.png",
                height: 45,
                width: 45,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 30.0,
            ),
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                "assets/pngs/apple1.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class LoginAndRegisterButton extends GetView<LoginController> {
  const LoginAndRegisterButton({
    super.key,
    required this.authController,
  });

  final LoginController authController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 80.0),
            ),
          ),
          onPressed: () async {
            if (authController.loginFormKey.currentState!.validate()) {
              try {
                LoginResponse loginResult = await authController.Login(
                  authController.loginEmailController.text,
                  Helpers.encryption(authController.loginPasswordController.text),
                );
                if (loginResult.success && loginResult.user.isApproved == 1) {
                  Get.offAll(const Dashboard());
                } else {
                  // ignore: use_build_context_synchronously
                  CustomDialog.showMessage(
                    context: context,
                    title: "Giriş Başarısız",
                    message: loginResult.message,
                  );
                }
              } catch (e) {
                print('Hata: $e');
                Get.snackbar('Hata', 'Giriş başarısız oldu. Lütfen tekrar deneyin.');
              }
            }
          },
          child: const Text(
            "Giriş Yap",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 15),
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 80.0),
            ),
          ),
          onPressed: () {
            Get.off(() => RegisterPage());
          },
          child: const Text("Kayıt Ol"),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Get.to(const Dashboard()),
          child: const Text(
            "Kayıt olmadan devam et",
            style: TextStyle(fontSize: 12, decoration: TextDecoration.underline, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class EmailAndPassword extends GetView<LoginController> {
  const EmailAndPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            validator: (value) => value!.isEmpty
                ? "Boş bırakılamaz"
                : !value.toString().isEmail
                    ? "Geçerli bir mail adresi giriniz."
                    : null,
            controller: controller.loginEmailController,
            decoration: InputDecoration(
                hintText: "Eposta",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.email_outlined)),
          ),
        ),
        const SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(() => Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0),
                  child: TextFormField(
                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                    obscureText: controller.passwordHide.isTrue,
                    controller: controller.loginPasswordController,
                    decoration: InputDecoration(
                      hintText: "Şifre",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                      fillColor: Colors.grey.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: GestureDetector(
                        onTap: () => controller.passwordHide.toggle(),
                        child: Icon(controller.passwordHide.isTrue ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextButton(
                onPressed: () => Get.to(ForgotPasswordPage()),
                child: const Text(
                  "Şifremi unuttum",
                  style: TextStyle(fontSize: 14, decoration: TextDecoration.underline, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
