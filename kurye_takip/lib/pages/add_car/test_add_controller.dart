// ignore_for_file: invalid_use_of_protected_member, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/car_add.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/widgets/images.dart';
import 'package:map_picker/map_picker.dart';

import '../../model/brand.dart';
import '../../model/model.dart';
import '../../service/api_service.dart';

class TestAddController extends GetxController {
  //General
  PageController pageController = PageController();

  // PAGE-1
  final testAddPageOneFormKey = GlobalKey<FormState>();
  RxBool loadingModels = false.obs;
  RxList<BrandElement> carBrandsList = <BrandElement>[].obs;
  RxList<ModelElement> carModelList = <ModelElement>[].obs;
  List<String> carYearList = ['2020', '2021', '2022', "2023", "2024"];
  List<String> carFuelTypeList = ['Hybrid', 'Benzin', 'Dizel'];
  List<String> carTransmissionTypeList = ['Otomatik', 'Manuel', 'Yarı Otomatik'];

  String? carBrand, carModel, carYear, carFuel, carTransmission;

  void changeBrand(value) {
    carBrand = value;
    loadingModels.value = true;
    carModel = null;
    fetchModels(int.parse(value));
  }

  Future<void> fetchBrands() async {
    if (carBrandsList.value.isEmpty) {
      try {
        List<BrandElement> brandList = await ApiService.fetchBrands();
        carBrandsList.assignAll(brandList);
      } catch (e) {
        log("Error fetching brands: $e");
      }
    }
  }

  Future<void> fetchModels(int brandId) async {
    try {
      List<ModelElement> modelList = await ApiService.fetchModels(brandId);
      carModelList.assignAll(modelList);
    } catch (e) {
      log("Error fetching models: $e");
    }
    loadingModels.value = false;
  }

  void checkPageOneComplete() async {
    if (testAddPageOneFormKey.currentState!.validate()) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli alanları doldurunuz.");
    }
  }

  // PAGE-2
  final testAddPageTwoFormKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  void checkPageTwoComplete() async {
    if (testAddPageTwoFormKey.currentState!.validate()) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli alanları doldurunuz.");
    }
  }

  // PAGE-3
  final testAddPageThreeKey = GlobalKey<FormState>();

  RxList<AddCarLocation> locations = <AddCarLocation>[].obs;

  MapPickerController mapPickerController = MapPickerController();
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4237, 27.1428), zoom: 14.4746);
  final googleMapController = Completer<GoogleMapController>();
  RxString gmAddressText = "".obs, rxCity = "".obs, rxDistrict = "".obs, address = "".obs;
  String district = "", city = "";
  List<String> kmList = ['0 - 29.999', '30.000 - 59.999', '60.000 - 89.999', '90.000 ve üzeri'];
  TextEditingController carPlate = TextEditingController();
  String? selectedKm;

  Future<void> openSelectLocationDialog() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // Konum iste iste
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14.4746);
    }
    Get.dialog(const TestAddSelectLocationCarOwner());
  }

  void checkPageThreeComplete() async {
    if (testAddPageThreeKey.currentState!.validate()) {
      if (locations.value.isNotEmpty) {
        pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      } else {
        Helpers.showSnackbar("Uyarı!", "Lütfen teslimat konumunu ekleyiniz.");
      }
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli alanları doldurunuz.");
    }
  }

  //PAGE-4
  final testAddPageFourKey = GlobalKey<FormState>();

  RxBool isGeneralTime = true.obs;

  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

  TimeOfDay availableWeekdayStartTime = TimeOfDay.now();
  TimeOfDay availableWeekdayEndTime = TimeOfDay.now();
  TimeOfDay availableWeekEndStartTime = TimeOfDay.now();
  TimeOfDay availableWeekEndEndTime = TimeOfDay.now();

  TimeOfDay availableMondayStartTime = TimeOfDay.now();
  TimeOfDay availableMondayEndTime = TimeOfDay.now();
  TimeOfDay availableTuesdayStartTime = TimeOfDay.now();
  TimeOfDay availableTuesdayEndTime = TimeOfDay.now();
  TimeOfDay availableWednesdayStartTime = TimeOfDay.now();
  TimeOfDay availableWednesdayEndTime = TimeOfDay.now();
  TimeOfDay availableThursdayStartTime = TimeOfDay.now();
  TimeOfDay availableThursdayEndTime = TimeOfDay.now();
  TimeOfDay availableFridayStartTime = TimeOfDay.now();
  TimeOfDay availableFridayEndTime = TimeOfDay.now();
  TimeOfDay availableSaturdayStartTime = TimeOfDay.now();
  TimeOfDay availableSaturdayEndTime = TimeOfDay.now();
  TimeOfDay availableSundayStartTime = TimeOfDay.now();
  TimeOfDay availableSundayEndTime = TimeOfDay.now();

  TextEditingController availableWeekdayStart = TextEditingController();
  TextEditingController availableWeekdayEnd = TextEditingController();
  TextEditingController availableWeekendStart = TextEditingController();
  TextEditingController availableWeekendEnd = TextEditingController();

  TextEditingController availableMondayStart = TextEditingController();
  TextEditingController availableMondayEnd = TextEditingController();
  TextEditingController availableTuesdayStart = TextEditingController();
  TextEditingController availableTuesdayEnd = TextEditingController();
  TextEditingController availableWednesdayStart = TextEditingController();
  TextEditingController availableWednesdayEnd = TextEditingController();
  TextEditingController availableThursdayStart = TextEditingController();
  TextEditingController availableThursdayEnd = TextEditingController();
  TextEditingController availableFridayStart = TextEditingController();
  TextEditingController availableFridayEnd = TextEditingController();
  TextEditingController availableSaturdayStart = TextEditingController();
  TextEditingController availableSaturdayEnd = TextEditingController();
  TextEditingController availableSundayStart = TextEditingController();
  TextEditingController availableSundayEnd = TextEditingController();

  void checkPageFourComplete() async {
    if (testAddPageFourKey.currentState!.validate()) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli alanları doldurunuz.");
    }
  }

  //PAGE-5
  RxList<AddCarUploadImage> carImages = <AddCarUploadImage>[
    AddCarUploadImage(header: "Ön", description: "Aracın önden fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    AddCarUploadImage(header: "Arka", description: "Aracın arkadan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    AddCarUploadImage(header: "Sağ", description: "Aracın sağ yandan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    AddCarUploadImage(header: "Sol", description: "Aracın sol yandan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    AddCarUploadImage(header: "Ön İç", description: "Aracın araç iç ön kısmının fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    AddCarUploadImage(header: "Arka İç", description: "Aracın araç iç arka kısmının fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    AddCarUploadImage(header: "Bagaj", description: "Aracın araç bagaj içi fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
  ].obs;

  Future<void> pickImageAtIndex(ImageSource source, int index) async {
    final XFile? image = await ImagePicker().pickImage(source: source, imageQuality: 25);
    if (image!.isNull == false) {
      carImages[index].ext = image.path.split(".").last;
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
          carImages[index].photo64 = base64Encode(compressedBytes);
          carImages[index].load.value = true;
        }
      }
    }
  }

  void removeImageAtIndex(int index) {
    carImages.value[index].load.value = false;
    carImages.value[index].ext = "";
    carImages.value[index].photo64 = "";
  }

  bool checkLoadImageComplete() {
    for (AddCarUploadImage item in carImages.value) {
      if (item.load.isFalse) return false;
    }
    return true;
  }

  void checkPageFiveComplete() async {
    if (checkLoadImageComplete()) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli fotoğrafları yükleyiniz.");
    }
  }

  //PAGE-6

  List<String> weeklyDiscountRateList = ['%0', '%5', '%10', "%20", "%30", "%40", "%50"];
  List<String> monthlyDiscountRateList = ['%0', '%5', '%10', "%20", "%30", "%40", "%50"];

  String? weeklyDiscount, monthlyDiscount;
  final testAddPageSixFormKey = GlobalKey<FormState>();

  TextEditingController dailyRentPrice = TextEditingController();

  Future<void> monthlyRentPriceCalculator() async {
    if (testAddPageSixFormKey.currentState!.validate()) {
      double monthlyPrice = double.parse(dailyRentPrice.text.trim()) * 30;
      Get.dialog(AppCustomDialog(title: "Aylık Kira Ücreti", message: "${monthlyPrice.toStringAsFixed(2)} ₺"));
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli alanları doldurunuz.");
    }
  }

  void checkPageSixComplete() async {
    if (testAddPageSixFormKey.currentState!.validate()) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli alanları doldurunuz.");
    }
  }

  //PAGE-7

  TextEditingController note = TextEditingController();
  final testAddPageSevenKey = GlobalKey<FormState>();
  TextEditingController minRentDay = TextEditingController();

  String? userId;

  //Once araç kaydı
  //Sonra fotoğraflarının kaydı
  Future saveCar() async {
    Map<String, dynamic> carMap = {
      "user_id": int.parse(getLocalUserID()),
      "brand_id": int.parse(carBrand.toString()),
      "model_id": int.parse(carModel.toString()),
      "fuel_type": carFuel.toString(),
      "transmission_type": carTransmission.toString(),
      "daily_price": int.parse(dailyRentPrice.text),
      "plate": carPlate.text,
      "km": selectedKm.toString(),
      "note": note.text,
      "weekly_rent": weeklyDiscount != null ? int.parse(weeklyDiscount!.replaceAll('%', '')) : 0,
      "monthly_rent": monthlyDiscount != null ? int.parse(monthlyDiscount!.replaceAll('%', '')) : 0,
      "min_rent_day": int.parse(minRentDay.text),
      "user_name": name.text,
      "user_surname": surname.text,
      "user_email": email.text,
      "user_phone": phone.text,
      "is_long_term": 0,
      "is_approved": 1
    };

    CarCreateResponse carCreateResponse = await ApiService.CarCreate(carMap);

    if (carCreateResponse.success == true) {
      log("araç başarıyla kaydedildi.");
      saveCarPhotos(carCreateResponse.carId);
      saveCarLocations(carCreateResponse.carId);
      saveCarDeliveryTimes(carCreateResponse.carId);
    }
  }

  Future<void> saveCarDeliveryTimes(int carId) async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");

    try {} catch (e) {
      log(e.toString());
    }
  }

  Future<void> saveCarPhotos(int carId) async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");
    try {
      for (int i = 0; i < carImages.length; i++) {
        Map<String, dynamic> carAddPhotoMap = {
          "car_id": carId,
          "base64_image": carImages[i].photo64,
          "ext": carImages[i].ext,
          "photo_type": i + 1,
        };
        generalResponse = await ApiService.CarAddPhoto(carAddPhotoMap);
        log(generalResponse.message);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> saveCarLocations(int carId) async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");

    try {
      for (int i = 0; i < locations.length; i++) {
        Map<String, dynamic> carAddLocationMap = {
          "city": locations[i].city,
          "district": locations[i].district,
          "address": locations[i].address,
          "latitude": double.parse(locations[i].latitude),
          "longitude": double.parse(locations[i].longitude)
        };
        generalResponse = await ApiService.CarAddLocations(carAddLocationMap);
        log(generalResponse.message);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  User user = User();

  String getLocalUserID() {
    final box = GetStorage();
    final userData = box.read('user_data');
    if (userData != null) {
      user = User.fromJson(userData);
      userId = Helpers.decryption(user.code.toString());
      return userId.toString();
    }
    return "";
  }
}

class AddCarUploadImage {
  RxBool load;
  String header;
  String description;
  String photo64;
  String ext;

  AddCarUploadImage({
    required this.description,
    required this.ext,
    required this.header,
    required this.load,
    required this.photo64,
  });
}

class AddCarLocation {
  String city;
  String district;
  String address;
  String latitude;
  String longitude;

  AddCarLocation({required this.latitude, required this.address, required this.city, required this.district, required this.longitude});
}
