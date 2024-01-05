import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.put(AuthController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/svgs/banner1.svg",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 32),
            Text("Kayıt Ol", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30.0),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    fillColor: Colors.grey.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.password)),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () {
                  authController.register(emailController.text, passwordController.text);
                },
                child: const Text("Kayıt Ol"))
          ],
        ),
      ),
    );

    /*Column(
      children: [
        //image
        //textfield
        //textfield
        //textfield
        //button()
        //Sign Up
      ],
    );*/
  }
}
