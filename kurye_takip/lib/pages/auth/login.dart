import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/components/my_popup.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/pages/auth/auth_controller.dart';
import 'package:kurye_takip/pages/auth/register.dart';
import 'package:kurye_takip/pages/dashboard/dashboard.dart';
import 'package:kurye_takip/pages/gnav_bar/gnav_bar.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.put(AuthController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            ImageAndText(),
            EmailAndPassword(
              emailController: emailController,
              passwordController: passwordController,
            ),
            LoginAndRegisterButton(
                authController: authController,
                emailController: emailController,
                passwordController: passwordController),
            //LoginWithGoogleAndApple(),
          ],
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
          child: Container(
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
        Text("Giriş Yap", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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
        Text(
          "Google yada Apple ile Giriş Yap",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
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
            SizedBox(
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

class LoginAndRegisterButton extends StatelessWidget {
  const LoginAndRegisterButton({
    super.key,
    required this.authController,
    required this.emailController,
    required this.passwordController,
  });

  final AuthController authController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 80.0),
            ),
          ),
          onPressed: () async {
            if (emailController.text.isEmpty || passwordController.text.isEmpty) {
              Get.dialog(
                MyPopup(
                  title: 'Hata',
                  message: 'Eposta veya şifre boş olamaz.',
                ),
              );
            } else {
              try {
                Login loginResult = await authController.login(
                  emailController.text,
                  Helpers.encryptPassword(passwordController.text),
                );
                if (loginResult.success) {
                  Get.snackbar("Başarılı", 'Giriş Baraşılı oldu');
                  Get.offAll(GoogleNavBar());
                } else {
                  Get.snackbar("Giriş Başarısız", loginResult.message);
                }
              } catch (e) {
                print('Hata: $e');
                Get.snackbar('Hata', 'Giriş başarısız oldu. Lütfen tekrar deneyin.');
              }
            }
          },
          child: Text(
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
              EdgeInsets.symmetric(horizontal: 80.0),
            ),
          ),
          onPressed: () {
            Get.off(() => RegisterPage());
          },
          child: Text("Kayıt Ol"),
        ),
      ],
    );
  }
}

class EmailAndPassword extends StatelessWidget {
  const EmailAndPassword({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
                hintText: "Eposta",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.email)),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
                hintText: "Şifre",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.password)),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
