import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/components/my_popup.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/helpers/location_selection_screen.dart';
import 'package:kurye_takip/pages/auth/auth_controller.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/auth/register2.dart';
import 'package:kurye_takip/pages/dashboard/dashboard.dart';
import 'package:kurye_takip/pages/map/map.dart';
import 'package:map_picker/map_picker.dart';

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

  TextEditingController rentNameController = TextEditingController();
  TextEditingController rentSurnameController = TextEditingController();
  TextEditingController rentPhoneController = TextEditingController();
  TextEditingController rentEmailController = TextEditingController();
  TextEditingController rentPasswordController = TextEditingController();
  TextEditingController rentPassword2Controller = TextEditingController();

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
                  drivingLicenseNumberController: drivingLicenseNumber,
                  drivingLicenseDateController: drivingLicenseDate,
                  authController: authController),
              AracKirayaVerTab(
                  rentNameController: rentNameController,
                  rentSurnameController: rentSurnameController,
                  rentPhoneController: rentPhoneController,
                  rentEmailController: rentEmailController,
                  rentPasswordController: rentPasswordController,
                  rentPassword2Controller: rentPassword2Controller,
                  authController: authController)
            ],
          ),
        ),
      ),
    );
  }
}

class AracKirayaVerTab extends StatelessWidget {
  const AracKirayaVerTab({
    super.key,
    required this.rentNameController,
    required this.rentSurnameController,
    required this.rentPhoneController,
    required this.rentEmailController,
    required this.rentPasswordController,
    required this.rentPassword2Controller,
    required this.authController,
  });

  final TextEditingController rentNameController;
  final TextEditingController rentSurnameController;
  final TextEditingController rentPhoneController;
  final TextEditingController rentEmailController;
  final TextEditingController rentPasswordController;
  final TextEditingController rentPassword2Controller;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Get.width * 0.9,
                ),
                child: TextField(
                  controller: rentNameController,
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
                  controller: rentSurnameController,
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
                  controller: rentPhoneController,
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
                  controller: rentEmailController,
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
                  controller: rentPasswordController,
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
                  controller: rentPassword2Controller,
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
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 50.0),
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
                        const EdgeInsets.symmetric(horizontal: 50.0),
                      ),
                    ),
                    onPressed: () async {
                      authController.registerModel.name = rentNameController.text;
                      authController.registerModel.surname = rentSurnameController.text;
                      authController.registerModel.phone = rentPhoneController.text;
                      authController.registerModel.email = rentNameController.text;
                      authController.registerModel.password = Helpers.encryptPassword(rentPasswordController.text);
                      authController.registerModel.is_vehicle_owner = 1;

                      await authController.register();
                    },
                    child: const Text("Kaydol", style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            GoogleAndAppleRegister(),
          ],
        ),
      ),
    );
  }
}

class AracKiralaTab extends StatelessWidget {
  AracKiralaTab({
    super.key,
    required this.nameController,
    required this.surnameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.password2Controller,
    required this.drivingLicenseNumberController,
    required this.drivingLicenseDateController,
    required this.authController,
  });

  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController password2Controller;
  final TextEditingController drivingLicenseNumberController;
  final TextEditingController drivingLicenseDateController;
  final AuthController authController;

  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(38.4237, 27.1428),
    zoom: 14.4746,
  );

  var textController = TextEditingController();

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
            DrivingLicenseNoDateFrontAndBack(
              surnameController: surnameController,
              authController: authController,
              drivingLicenseNumberController: drivingLicenseNumberController,
              drivingLicenseDateController: drivingLicenseDateController,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  _showMapPickerModal(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Konumunuzu Seçin'),
                    const SizedBox(width: 10),
                    Obx(() {
                      switch (authController.isLocationTaken.value) {
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
            ),

            const SizedBox(height: 10),

            //TextButton(onPressed: () {}, child: Text("Konumunuzu seçiniz")),
            LoginAndRegisterButton(
              nameController: nameController,
              surnameController: surnameController,
              phoneController: phoneController,
              emailController: emailController,
              passwordController: passwordController,
              password2Controller: password2Controller,
              authController: authController,
              drivingLicenseNumberController: drivingLicenseNumberController,
              drivingLicenseDateController: drivingLicenseDateController,
            ),
            const GoogleAndAppleRegister(),
          ],
        ),
      ),
    );
  }

  void _showMapPickerModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            height: Get.height * 0.5,
            width: Get.width * 0.9,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                MapPicker(
                  // pass icon widget
                  iconWidget: Image.asset("assets/pngs/location_icon.png"),
                  // add map picker controller
                  mapPickerController: mapPickerController,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    // hide location button
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    // camera position
                    initialCameraPosition: cameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraMoveStarted: () {
                      // notify map is moving
                      mapPickerController.mapMoving!();
                      textController.text = "Kontrol Ediliyor...";
                    },
                    onCameraMove: (cameraPosition) {
                      this.cameraPosition = cameraPosition;
                    },
                    onCameraIdle: () async {
                      // notify map stopped moving
                      mapPickerController.mapFinishedMoving!();
                      // get address name from camera position
                      List<Placemark> placemarks = await placemarkFromCoordinates(
                        cameraPosition.target.latitude,
                        cameraPosition.target.longitude,
                      );

                      // update the ui with the address
                      textController.text = '${placemarks.first.administrativeArea} - ${placemarks.first.subLocality}';
                      String fullAddress =
                          '${placemarks.first.thoroughfare} ${placemarks.first.subThoroughfare}, ${placemarks.first.locality} ${placemarks.first.subLocality}, ${placemarks.first.administrativeArea} ${placemarks.first.postalCode}';
                      authController.registerModel.address = fullAddress;
                      authController.registerModel.city = placemarks.first.administrativeArea!;
                      authController.registerModel.district = placemarks.first.subLocality!;
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).viewPadding.top + 20,
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  child: TextFormField(
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: const InputDecoration(contentPadding: EdgeInsets.zero, border: InputBorder.none),
                    controller: textController,
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      child: const Text(
                        "Konumu Seç",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: Color(0xFFFFFFFF),
                          fontSize: 19,
                          // height: 19/19,
                        ),
                      ),
                      onPressed: () {
                        print("Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                        print("Address: ${textController.text}");

                        authController.isLocationTaken.value = 1;

                        Navigator.of(context).pop(); // Close the dialog
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFA3080C)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class DrivingLicenseNoDateFrontAndBack extends StatelessWidget {
  DrivingLicenseNoDateFrontAndBack({
    super.key,
    required this.surnameController,
    required this.authController,
    required this.drivingLicenseNumberController,
    required this.drivingLicenseDateController,
  });

  final TextEditingController surnameController;
  final AuthController authController;
  final TextEditingController drivingLicenseNumberController;
  final TextEditingController drivingLicenseDateController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.9,
            ),
            child: TextField(
              controller: drivingLicenseNumberController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Ehliyet Numarası",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
              controller: drivingLicenseDateController,
              style: const TextStyle(fontSize: 14),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            onPressed: () async {
              final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
              print(image);

              if (image != null) {
                authController.isDrivingLicenseFrontImageTaken.value = 1;

                List<int> imageBytes = await image.readAsBytes();
                String base64Image = base64Encode(imageBytes);

                authController.registerModel.drivingLicenseFrontImage = base64Encode(imageBytes);

                _showResultDialog(true, context);
              } else {
                authController.isDrivingLicenseFrontImageTaken.value = 2;
                _showResultDialog(false, context);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ehliyet Ön Yüz Fotoğrafını Çek'),
                const SizedBox(width: 10),
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
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            onPressed: () async {
              final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

              if (image != null) {
                authController.isDrivingLicenseBackImageTaken.value = 1;

                List<int> imageBytes = await image.readAsBytes();
                String base64Image = base64Encode(imageBytes);

                /*
                storage.write('drivingLicenseBack', base64Image);
                print("Front  ${storage.read<String>('drivingLicenseBack')}");*/

                authController.registerModel.drivingLicenseBackImage = base64Encode(imageBytes);

                _showResultDialog(true, context);
              } else {
                authController.isDrivingLicenseBackImageTaken.value = 2;
                _showResultDialog(false, context);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ehliyet Arka Yüz Fotoğrafını Çek'),
                const SizedBox(width: 10),
                Obx(() {
                  switch (authController.isDrivingLicenseBackImageTaken.value) {
                    case 1:
                      return const Icon(Icons.check, color: Colors.green);
                    case 2:
                      return const Icon(Icons.close, color: Colors.red);
                    default:
                      return Container();
                  }
                }),
              ],
            ),
          ),
        ),
      ],
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
    required this.drivingLicenseNumberController,
    required this.drivingLicenseDateController,
  });

  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController password2Controller;
  final AuthController authController;
  final TextEditingController drivingLicenseNumberController;
  final TextEditingController drivingLicenseDateController;

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
                const EdgeInsets.symmetric(horizontal: 50.0),
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
                const EdgeInsets.symmetric(horizontal: 50.0),
              ),
            ),
            onPressed: () async {
              authController.registerModel.name = nameController.text;
              authController.registerModel.surname = surnameController.text;
              authController.registerModel.phone = phoneController.text;
              authController.registerModel.email = emailController.text;
              authController.registerModel.password = Helpers.encryptPassword(emailController.text);
              authController.registerModel.drivingLicenseNumber = drivingLicenseNumberController.text;
              authController.registerModel.drivingLicenseDate = drivingLicenseDateController.text;
              authController.registerModel.is_vehicle_owner = 0;

              await authController.register();
            },
            child: const Text("Kaydol", style: TextStyle(fontSize: 18)),
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
