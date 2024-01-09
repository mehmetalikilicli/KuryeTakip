import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/components/my_popup.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/pages/auth/auth_controller.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/auth/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController authController = Get.put(AuthController());

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            GetUserInfo(
                nameController: nameController,
                surnameController: surnameController,
                phoneController: phoneController,
                emailController: emailController,
                passwordController: passwordController,
                password2Controller: password2Controller),
            LoginAndRegisterButton(
              nameController: nameController,
              surnameController: surnameController,
              phoneController: phoneController,
              emailController: emailController,
              passwordController: passwordController,
              password2Controller: password2Controller,
              authController: authController,
            ),
            const GoogleAndAppleRegister(),
          ],
        ),
      ),
    );
  }
}

class GoogleAndAppleRegister extends StatelessWidget {
  const GoogleAndAppleRegister({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text(
          "Google yada Apple ile Kayıt Ol",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30.0),
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
            const SizedBox(width: 30.0),
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
    required this.nameController,
    required this.surnameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.password2Controller,
    required this.authController,
  });

  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController password2Controller;
  final AuthController authController;

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
            /*
            if (passwordController.text != password2Controller.text) {
              Get.dialog(MyPopup(
                title: 'Hata',
                message: 'Kayıt başarısız oldu. Şifreniz eşleşmiyor.',
              ));
            } else {
              RegisterModel registerData = RegisterModel(
                name: nameController.text,
                phone: phoneController.text,
                email: emailController.text,
                password: Helpers.encryptPassword(passwordController.text),
              );

              try {
                Register registerResult = await authController.register(registerData);

                if (registerResult.success) {
                  print("Kayıt başarılı");
                  Get.to(LoginPage());
                } else {
                  print("Kayıt başarısız");
                  Get.snackbar('Hata', 'Kayıt başarısız oldu. ${registerResult.message}');
                }
              } catch (e) {
                // Hata durumunda yapılacak işlemler
                print('Hata: $e');
                Get.snackbar('Hata', 'Kayıt başarısız oldu.');
                throw Exception(e);
              }
            }*/
          },
          child: const Text("İleri", style: TextStyle(fontSize: 20)),
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
            Get.to(() => LoginPage());
          },
          child: const Text("Girişe Dön"),
        ),
      ],
    );
  }
}

class GetUserInfo extends StatelessWidget {
  const GetUserInfo({
    super.key,
    required this.nameController,
    required this.surnameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.password2Controller,
  });

  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController password2Controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text("Kayıt Ol", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
                hintText: "İsim",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person)),
          ),
        ),
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextField(
            controller: surnameController,
            decoration: InputDecoration(
                hintText: "Soyisim",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person)),
          ),
        ),
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextField(
            controller: phoneController,
            decoration: InputDecoration(
                hintText: "Telefon",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.phone)),
          ),
        ),
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
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "Şifre",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.password)),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextField(
            controller: password2Controller,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "Şifre Tekrar",
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
