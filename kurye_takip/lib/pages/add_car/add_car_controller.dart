import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:map_picker/map_picker.dart';

class AddCarController extends GetxController {
  final PageController addCarPageController = PageController();

  final addCarFormKey = GlobalKey<FormState>();
  final addCarFormKey2 = GlobalKey<FormState>();
  final addCarFormKey3 = GlobalKey<FormState>();
  final addCarFormKey4 = GlobalKey<FormState>();
  final addCarFormKey5 = GlobalKey<FormState>();

  @override
  void onInit() {
    getLocalUser();
    super.onInit();
  }

  //Page1

  RxString carBrand = "".obs;
  RxString carModel = "".obs;
  RxString carYear = "".obs;
  RxString carFuelType = "".obs;
  RxString transmissionType = "".obs;

  RxString brandDropdownHint = 'Marka Seçiniz'.obs;
  RxString modelDropdownHint = 'Model Seçiniz'.obs;
  RxString yearDropdownHint = 'Yıl Seçiniz'.obs;
  RxString fuelTypeDropdownHint = 'Yakıt Tipi Seçiniz'.obs;
  RxString transmissionTypeDropdownHint = 'Vites Tipi Seçiniz'.obs;

  List<String> carBrandsList = ['Toyota', 'Honda', 'Ford', 'Volkswagen', 'Renault'];
  List<String> carModelList = ['Corolla', 'Camry', 'RAV4', 'Prius'];
  List<String> carFuelTypeList = ['Hybrid', 'Benzin', 'Dizel'];
  List<String> carTransmissionTypeList = ['Otomatik', 'Manuel', 'Yarı Otomatik'];
  List<String> carYearList = ['2020', '2021', '2022', "2023", "2024"];

  //Page2

  User user = User();

  int dailyRentMoney = 0;

  TextEditingController rentName = TextEditingController();
  TextEditingController rentSurname = TextEditingController();
  TextEditingController rentMail = TextEditingController();
  TextEditingController rentPhone = TextEditingController();

  //Page3

  TextEditingController plateNumberController = TextEditingController();

  RxString kmDropdownHint = 'Km Aralığı Seçiniz'.obs;

  List<String> kmList = ['0 - 29.999', '30.000 - 59.999', '60.000 - 89.999', '90.000 ve üzeri'];

  MapPickerController mapPickerController = MapPickerController();
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4237, 27.1428), zoom: 14.4746);
  final googleMapController = Completer<GoogleMapController>();
  RxString gmAddressText = "".obs, rxCity = "".obs, rxDistrict = "".obs;
  RxString address = "".obs;
  String district = "", city = "";

  void getLocalUser() {
    final box = GetStorage();
    final userData = box.read('user_data');
    if (userData != null) {
      user = User.fromJson(userData);
      rentName.text = user.name ?? "";
      rentSurname.text = user.surname ?? "";
      rentPhone.text = user.phone ?? "";
      rentMail.text = user.email ?? "";
    }
  }

  Future<int> getDailyRentMoney(String carBrand, String carModel) async {
    // await addCarService.getDailyRentMoney
    dailyRentMoney = 500;
    return dailyRentMoney;
  }
}
