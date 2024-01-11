import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/service/auth_service.dart';
import 'package:map_picker/map_picker.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();

  final rentForm = GlobalKey<FormState>();
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

  DateTime rentDLdate = DateTime.now();

  String image1 = "", image2 = "", image1ext = "", image2ext = "";

  RxBool rentPasswordHide = true.obs, rentPassword2Hide = true.obs;

  MapPickerController mapPickerController = MapPickerController();
  final googleMapController = Completer<GoogleMapController>();
  RxString gmAddressText = "".obs, rxCity = "".obs, rxDistrict = "".obs;

  RxString address = "".obs;
  String district = "", city = "";

  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4237, 27.1428), zoom: 14.4746);
}
