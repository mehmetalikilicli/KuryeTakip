import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/controllers/auth_controller.dart';
import 'package:kurye_takip/pages/auth/register.dart';

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
      body: SafeArea(
          child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SvgPicture.asset(
              "assets/svgs/banner1.svg",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          const SizedBox(height: 15),
          Text("Giriş Yap", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Email",
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
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  fillColor: Colors.grey.withOpacity(0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.password)),
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
              authController.login(emailController.text, passwordController.text);
            },
            child: Text("Giriş Yap"),
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
              Get.to(RegisterPage());
            },
            child: Text("Kayıt Ol"),
          ),
          const SizedBox(height: 15),
          Text(
            "or Login with",
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
      )),
    );
  }
}
