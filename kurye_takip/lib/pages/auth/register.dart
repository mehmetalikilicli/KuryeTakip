import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/components/my_popup.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/helpers/location_selection_screen.dart';
import 'package:kurye_takip/pages/auth/auth_controller.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/auth/register2.dart';

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

  TextEditingController drivingLicenseNumber = TextEditingController();
  TextEditingController drivingLicenseDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            bottom: const TabBar(
              indicatorPadding: EdgeInsets.all(0),
              tabs: [
                Center(child: Text("Araç Kirala")),
                Center(child: Text("Araç Kiraya Ver")),
              ],
            ),
            title: const Text('RENTEKER'),
          ),
          resizeToAvoidBottomInset: false,
          body: TabBarView(
            children: [
              AracKiralaTab(
                  nameController: nameController,
                  surnameController: surnameController,
                  phoneController: phoneController,
                  emailController: emailController,
                  passwordController: passwordController,
                  password2Controller: password2Controller,
                  drivingLicenseNumber: drivingLicenseNumber,
                  drivingLicenseDate: drivingLicenseDate,
                  authController: authController),
              AracKiralaTab(
                  nameController: nameController,
                  surnameController: surnameController,
                  phoneController: phoneController,
                  emailController: emailController,
                  passwordController: passwordController,
                  password2Controller: password2Controller,
                  drivingLicenseNumber: drivingLicenseNumber,
                  drivingLicenseDate: drivingLicenseDate,
                  authController: authController),
            ],
          ),
        ),
      ),
    );
  }
}

//--------------------------------------------------

class AracKiralaTab extends StatelessWidget {
  const AracKiralaTab({
    super.key,
    required this.nameController,
    required this.surnameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.password2Controller,
    required this.drivingLicenseNumber,
    required this.drivingLicenseDate,
    required this.authController,
  });

  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController password2Controller;
  final TextEditingController drivingLicenseNumber;
  final TextEditingController drivingLicenseDate;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final GetStorage storage = GetStorage();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GetUserInfo(
              nameController: nameController,
              surnameController: surnameController,
              phoneController: phoneController,
              emailController: emailController,
              passwordController: passwordController,
              password2Controller: password2Controller,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Get.width * 0.9,
                    ),
                    child: TextField(
                      controller: surnameController,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Ehliyet Numarası",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey.withOpacity(0.2),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Get.width * 0.9,
                    ),
                    child: TextField(
                      controller: surnameController,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Ehliyet Tarihi",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey.withOpacity(0.2),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        prefixIcon: const Icon(Icons.date_range_outlined),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                    print(image);

                    if (image != null) {
                      authController.isDrivingLicenseFrontImageTaken.value = 1;

                      List<int> imageBytes = await image.readAsBytes();
                      String base64Image = base64Encode(imageBytes);
                      storage.write('drivingLicenseFront', base64Image);

                      print("Front  ${storage.read<String>('drivingLicenseFront')}");

                      _showResultDialog(true, context);
                    } else {
                      authController.isDrivingLicenseFrontImageTaken.value = 2;
                      _showResultDialog(false, context);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Ehliyet Ön Yüz Fotoğrafını Çek'),
                      Obx(() {
                        switch (authController.isDrivingLicenseFrontImageTaken.value) {
                          case 1:
                            return Icon(Icons.check, color: Colors.green);
                          case 2:
                            return Icon(Icons.close, color: Colors.red);
                          default:
                            return Container();
                        }
                      }),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

                    if (image != null) {
                      authController.isDrivingLicenseBackImageTaken.value = 1;

                      List<int> imageBytes = await image.readAsBytes();
                      String base64Image = base64Encode(imageBytes);
                      storage.write('drivingLicenseBack', base64Image);

                      print("Front  ${storage.read<String>('drivingLicenseBack')}");

                      _showResultDialog(true, context);
                    } else {
                      authController.isDrivingLicenseBackImageTaken.value = 2;
                      _showResultDialog(false, context);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Ehliyet Arka Yüz Fotoğrafını Çek'),
                      Obx(() {
                        switch (authController.isDrivingLicenseBackImageTaken.value) {
                          case 1:
                            return Icon(Icons.check, color: Colors.green);
                          case 2:
                            return Icon(Icons.close, color: Colors.red);
                          default:
                            return Container();
                        }
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),

            //TextButton(onPressed: () {}, child: Text("Konumunuzu seçiniz")),
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

void _showResultDialog(bool isSuccess, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: isSuccess ? Icon(Icons.check, color: Colors.green) : Icon(Icons.close, color: Colors.red),
        content: isSuccess ? Text('İşlem başarıyla tamamlandı.') : Text('Resim alınamadı.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Tamam'),
          ),
        ],
      );
    },
  );
}

void openCamera() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.camera);

  if (image != null) {
    // Seçilen fotoğrafı kullanmak için buraya işlemleri ekleyebilirsiniz.
    print('Fotoğraf Yüklendi: ${image.path}');
  } else {
    print('Kullanıcı fotoğraf seçmedi');
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
        const SizedBox(height: 10),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
              backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 60.0),
              ),
            ),
            onPressed: () {
              Get.to(() => LoginPage());
            },
            child: const Text("Girişe Dön"),
          ),
          const SizedBox(height: 10),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
              backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 60.0),
              ),
            ),
            onPressed: () async {
              Get.to(() => Register2Page());
            },
            child: const Text("İleri", style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.9,
            ),
            child: TextField(
              controller: nameController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "İsim",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.9,
            ),
            child: TextField(
              controller: surnameController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Soyisim",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.9,
            ),
            child: TextField(
              controller: phoneController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Telefon",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.9,
            ),
            child: TextField(
              controller: emailController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Eposta",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.9,
            ),
            child: TextField(
              controller: passwordController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Şifre",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                prefixIcon: const Icon(Icons.password_outlined),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.9,
            ),
            child: TextField(
              controller: password2Controller,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Şifre Tekrar",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                prefixIcon: const Icon(Icons.password_outlined),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
