// ignore_for_file: non_constant_identifier_names, deprecated_member_use, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/widgets/images.dart';
import 'package:kurye_takip/service/auth_service.dart';
import 'package:map_picker/map_picker.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();

  final rentForm = GlobalKey<FormState>();
  final rentForm2 = GlobalKey<FormState>();
  final rentForm3 = GlobalKey<FormState>();
  final ownerForm = GlobalKey<FormState>();

  final PageController rentPageController = PageController();
  final PageController ownerPageController = PageController();

  TextEditingController rentName = TextEditingController();
  TextEditingController rentSurname = TextEditingController();
  TextEditingController rentMail = TextEditingController();
  TextEditingController rentTC = TextEditingController();
  TextEditingController rentPhone = TextEditingController();
  TextEditingController rentPassword = TextEditingController();
  TextEditingController rentPassword2 = TextEditingController();
  TextEditingController rentDLnumber = TextEditingController();
  TextEditingController rentDLdateInput = TextEditingController();
  TextEditingController rentBirthDateInput = TextEditingController();
  TextEditingController rentSerialNumber = TextEditingController();

  TextEditingController ownerName = TextEditingController();
  TextEditingController ownerSurname = TextEditingController();
  TextEditingController ownerMail = TextEditingController();
  TextEditingController ownerPhone = TextEditingController();
  TextEditingController ownerPassword = TextEditingController();
  TextEditingController ownerPassword2 = TextEditingController();

  RegisterModel registerModel = RegisterModel();
  RegisterModel registerModel2 = RegisterModel();

  DateTime rentDLdate = DateTime.now();
  DateTime rentBirthDate = DateTime.now();

  RxString rentGender = "".obs;

  String image1 = "", image2 = "", image1ext = "", image2ext = "";

  RxBool rentPasswordHide = true.obs, rentPassword2Hide = true.obs;

  RxBool ownerPasswordHide = true.obs, ownerPassword2Hide = true.obs;

  MapPickerController mapPickerController = MapPickerController();
  final googleMapController = Completer<GoogleMapController>();
  RxString gmAddressText = "".obs, rxCity = "".obs, rxDistrict = "".obs;

  RxString address = "".obs;
  String district = "", city = "";

  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4237, 27.1428), zoom: 14.4746);

  Future<RegisterResponse> Register(RegisterModel registerModel) async {
    try {
      RegisterResponse result = await _authService.register(registerModel);
      return result;
    } catch (e) {
      Get.snackbar('Hata', 'Kayıt başarısız oldu. Lütfen tekrar deneyin.');
      throw Exception(e);
    }
  }

  Future<void> pickImageAtFrontOrBack(ImageSource source, int frontOrBack) async {
    final XFile? image = await ImagePicker().pickImage(source: source, imageQuality: 25);
    if (image!.isNull == false) {
      //0 front
      frontOrBack == 0 ? image1ext = image.path.split(".").last : image2ext = image.path.split(".").last;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: AppImages().cropRatios,
        uiSettings: AppImages().cropSettings,
      );
      if (croppedFile != null) {
        Uint8List bytes = await croppedFile.readAsBytes();
        Uint8List compressedBytes = await FlutterImageCompress.compressWithList(bytes, minHeight: 400, minWidth: 300, quality: 50, rotate: 0);
        if (compressedBytes.length > 2.5 * 1024 * 1024) {
          Helpers.showSnackbar("Uyarı!", "Maksimum fotoğraf boyutunun üzerindedir. Lütfen daha düşük boyutlu fotoğraflar kullanınınz.");
        } else {
          frontOrBack == 0 ? image1 = base64Encode(compressedBytes) : image2 = base64Encode(compressedBytes);
        }
      }
    }
  }

/*
  Future<void> saveUserData(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert User object to JSON string
    String userJson = json.encode(user.toJson());

    // Save the JSON string to SharedPreferences
    await prefs.setString('user_data', userJson);
  }*/
}

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  final markers = RxSet<Marker>();

  var selectedCity = 'Izmir'.obs;
  var selectedDistrict = 'Bornova'.obs;

  RxInt isDrivingLicenseFrontImageTaken = 0.obs;
  RxInt isDrivingLicenseBackImageTaken = 0.obs;
  RxInt isLocationTaken = 0.obs;

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final rentRegisterFormKey = GlobalKey<FormState>();

  //Login TextEditingControllers
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  RegisterModel registerModel = RegisterModel();

  Future<LoginResponse> Login(String email, String cyriptedPassword) async {
    try {
      LoginResponse result = await _authService.login(email, cyriptedPassword);
      final box = GetStorage();
      await box.write('user_data', result.user.toJson());
      //await saveUserData(result.user);
      //print(result.user.code);
      return result;
    } catch (e) {
      print('Hata: $e');
      Get.snackbar('Hata', 'Giriş başarısız oldu. Lütfen tekrar deneyin.');
      throw Exception(e);
    }
  }

  /*Future<void> saveUserData(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert User object to JSON string
    String userJson = json.encode(user.toJson());

    // Save the JSON string to SharedPreferences
    await prefs.setString('user_data', userJson);
  }*/
}
