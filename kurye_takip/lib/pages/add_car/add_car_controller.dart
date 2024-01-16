import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurye_takip/model/brand.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/model/model.dart';
import 'package:kurye_takip/service/api_service.dart';
import 'package:map_picker/map_picker.dart';

class AddCarController extends GetxController {
  final PageController addCarPageController = PageController();

  final addCarFormKey = GlobalKey<FormState>();
  final addCarFormKey2 = GlobalKey<FormState>();
  final addCarFormKey3 = GlobalKey<FormState>();
  final addCarFormKey4 = GlobalKey<FormState>();
  final addCarFormKey5 = GlobalKey<FormState>();

  ApiService apiService = ApiService();

  @override
  void onInit() {
    getLocalUser();
    fetchBrands();
    super.onInit();
  }

  //Page1

  TextEditingController dailyRentMoney = TextEditingController();

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

  RxList<BrandElement> carBrandsList = <BrandElement>[].obs;
  RxList<ModelElement> carModelList = <ModelElement>[].obs;

  List<String> carFuelTypeList = ['Hybrid', 'Benzin', 'Dizel'];
  List<String> carTransmissionTypeList = ['Otomatik', 'Manuel', 'Yarı Otomatik'];
  List<String> carYearList = ['2020', '2021', '2022', "2023", "2024"];

  Future<void> fetchBrands() async {
    try {
      List<BrandElement> brandList = await ApiService.fetchBrands();
      carBrandsList.assignAll(brandList);
    } catch (e) {
      print("Error fetching brands: $e");
    }
  }

  Future<void> fetchModels(int brandId) async {
    try {
      List<ModelElement> modelList = await ApiService.fetchModels(brandId);
      carModelList.assignAll(modelList);
    } catch (e) {
      print("Error fetching models: $e");
    }
  }

  //Page2

  User user = User();

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
}
