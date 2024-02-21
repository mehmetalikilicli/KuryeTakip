// ignore_for_file: unused_local_variable, invalid_use_of_protected_member, deprecated_member_use, non_constant_identifier_names, duplicate_ignore

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/components/lists.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/brand.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/model/model.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/my_cars_detail/my_cars_detail.dart';
import 'package:kurye_takip/pages/widgets/images.dart';
import 'package:kurye_takip/service/api_service.dart';
import 'package:map_picker/map_picker.dart';

class MyCarsDetailController extends GetxController {
  CarElement carElement = CarElement();

  // ignore: non_constant_identifier_names
  Future<void> FillInfo() async {
    //Owner Info
    nameController.text = carElement.userName ?? "";
    surnameController.text = carElement.userSurname ?? "";
    phoneController.text = carElement.userPhone ?? "";
    emailController.text = carElement.userEmail ?? "";

    //Time Info
    availableCarDateStart = carElement.is_available_date_start ?? DateTime.now();
    availableCarDateEnd = carElement.is_available_date_end ?? DateTime.now();
    availableCarDate.text = "${DateFormat('dd.MM.yyyy').format(availableCarDateStart)} - ${DateFormat('dd.MM.yyyy').format(availableCarDateEnd)}";

    Future.microtask(() {
      note.text = carElement.note!;
    });

    //Locations
    //locations.value = carElement.carAvailableLocations;

    FillTimes();
    getLocations();
    fillPriceAndDiscount();
    fillPhotos(carElement.carAddPhotos!);

    isActive.value = carElement.isActive!;
    isApproved.value = carElement.isApproved!;
  }

  void fillPhotos(List<CarAddPhoto> carAddPhotos) {
    for (int i = 0; i < carAddPhotos.length; i++) {
      int photoType = carAddPhotos[i].photoType;

      // İlgili photo_type'a karşılık gelen index'i bul
      int imageIndex = carImages.indexWhere((image) => image.photoType == photoType);

      // Eğer index bulunursa, path'i güncelle
      if (imageIndex != -1) {
        carImages[imageIndex].path = carAddPhotos[i].photoPath;
      }
    }
  }

  void FillTimes() {
    // Hafta İçi Değerine Pazartesi atanacak
    startTimes[7] = convertStringToTimeOfDay(carElement.carDeliveryTimes!.first.startTime);
    endTimes[7] = convertStringToTimeOfDay(carElement.carDeliveryTimes!.first.endTime);
    availableWeekdayStart.text = getTimeString(startTimes[7]);
    availableWeekdayEnd.text = getTimeString(endTimes[7]);
    // Hafta Sonu Değerine Cumartesi atanacak
    startTimes[8] = convertStringToTimeOfDay(carElement.carDeliveryTimes!.last.startTime);
    endTimes[8] = convertStringToTimeOfDay(carElement.carDeliveryTimes!.last.endTime);
    availableWeekendStart.text = getTimeString(startTimes[8]);
    availableWeekendEnd.text = getTimeString(endTimes[8]);
    //Pazartesi değeri doldurulacak.
    startTimes[0] = convertStringToTimeOfDay(carElement.carDeliveryTimes!.first.startTime);
    endTimes[0] = convertStringToTimeOfDay(carElement.carDeliveryTimes!.first.endTime);
    availableMondayStart.text = getTimeString(startTimes[0]);
    availableMondayEnd.text = getTimeString(endTimes[0]);
    //Salı değeri doldurulacak.
    startTimes[1] = convertStringToTimeOfDay(carElement.carDeliveryTimes![1].startTime);
    endTimes[1] = convertStringToTimeOfDay(carElement.carDeliveryTimes![1].endTime);
    availableTuesdayStart.text = getTimeString(startTimes[1]);
    availableTuesdayEnd.text = getTimeString(endTimes[1]);
    //Çarşamba değeri doldurulacak.
    startTimes[2] = convertStringToTimeOfDay(carElement.carDeliveryTimes![2].startTime);
    endTimes[2] = convertStringToTimeOfDay(carElement.carDeliveryTimes![2].endTime);
    availableWednesdayStart.text = getTimeString(startTimes[2]);
    availableWednesdayEnd.text = getTimeString(endTimes[2]);
    //Perşembe değeri doldurulacak.
    startTimes[3] = convertStringToTimeOfDay(carElement.carDeliveryTimes![3].startTime);
    endTimes[3] = convertStringToTimeOfDay(carElement.carDeliveryTimes![3].endTime);
    availableThursdayStart.text = getTimeString(startTimes[3]);
    availableThursdayEnd.text = getTimeString(endTimes[3]);
    //Cuma değeri doldurulacak.
    startTimes[4] = convertStringToTimeOfDay(carElement.carDeliveryTimes![4].startTime);
    endTimes[4] = convertStringToTimeOfDay(carElement.carDeliveryTimes![4].endTime);
    availableFridayStart.text = getTimeString(startTimes[4]);
    availableFridayEnd.text = getTimeString(endTimes[4]);
    //Cumartesi değeri doldurulacak.
    startTimes[8] = convertStringToTimeOfDay(carElement.carDeliveryTimes!.last.startTime);
    endTimes[8] = convertStringToTimeOfDay(carElement.carDeliveryTimes!.last.endTime);
    availableSaturdayStart.text = getTimeString(startTimes[8]);
    availableSaturdayEnd.text = getTimeString(endTimes[8]);
    //Pazar değeri doldurulacak.
    startTimes[8] = convertStringToTimeOfDay(carElement.carDeliveryTimes!.last.startTime);
    endTimes[8] = convertStringToTimeOfDay(carElement.carDeliveryTimes!.last.endTime);
    availableSundayStart.text = getTimeString(startTimes[8]);
    availableSundayEnd.text = getTimeString(endTimes[8]);

    /*
    availableWeekdayStartTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![0].startTime);
    availableWeekdayStart.text = '${availableWeekdayStartTime.hour}:${availableWeekdayStartTime.minute}';

    availableWeekdayEndTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![0].endTime);
    availableWeekdayEnd.text = '${availableWeekdayEndTime.hour}:${availableWeekdayEndTime.minute}';

    availableWeekEndStartTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![5].startTime);
    availableWeekendStart.text = '${availableWeekEndStartTime.hour}:${availableWeekEndStartTime.minute}';

    availableWeekEndEndTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![5].startTime);
    availableWeekendEnd.text = '${availableWeekEndEndTime.hour}:${availableWeekEndEndTime.minute}';

    if (carElement.carDeliveryTimes != null && carElement.carDeliveryTimes!.isNotEmpty) {
      // Pazartesi
      availableMondayStartTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![1].startTime);
      availableMondayStart.text = '${availableMondayStartTime.hour}:${availableMondayStartTime.minute}';
      availableMondayEndTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![1].endTime);
      availableMondayEnd.text = '${availableMondayEndTime.hour}:${availableMondayEndTime.minute}';

      // Salı
      availableTuesdayStartTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![2].startTime);
      availableTuesdayStart.text = '${availableTuesdayStartTime.hour}:${availableTuesdayStartTime.minute}';
      availableTuesdayEndTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![2].endTime);
      availableTuesdayEnd.text = '${availableTuesdayEndTime.hour}:${availableTuesdayEndTime.minute}';

      // Çarşamba
      availableWednesdayStartTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![3].startTime);
      availableWednesdayStart.text = '${availableWednesdayStartTime.hour}:${availableWednesdayStartTime.minute}';
      availableWednesdayEndTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![3].endTime);
      availableWednesdayEnd.text = '${availableWednesdayEndTime.hour}:${availableWednesdayEndTime.minute}';

      // Perşembe
      availableThursdayStartTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![4].startTime);
      availableThursdayStart.text = '${availableThursdayStartTime.hour}:${availableThursdayStartTime.minute}';
      availableThursdayEndTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![4].endTime);
      availableThursdayEnd.text = '${availableThursdayEndTime.hour}:${availableThursdayEndTime.minute}';

      // Cuma
      availableFridayStartTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![5].startTime);
      availableFridayStart.text = '${availableFridayStartTime.hour}:${availableFridayStartTime.minute}';
      availableFridayEndTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![5].endTime);
      availableFridayEnd.text = '${availableFridayEndTime.hour}:${availableFridayEndTime.minute}';

      // Cumartesi
      availableSaturdayStartTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![6].startTime);
      availableSaturdayStart.text = '${availableSaturdayStartTime.hour}:${availableSaturdayStartTime.minute}';
      availableSaturdayEndTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![6].endTime);
      availableSaturdayEnd.text = '${availableSaturdayEndTime.hour}:${availableSaturdayEndTime.minute}';

      // Pazar
      availableSundayStartTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![0].startTime);
      availableSundayStart.text = '${availableSundayStartTime.hour}:${availableSundayStartTime.minute}';
      availableSundayEndTime = convertStringToTimeOfDay(carElement.carDeliveryTimes![0].endTime);
      availableSundayEnd.text = '${availableSundayEndTime.hour}:${availableSundayEndTime.minute}';
    }
    */
  }

  TimeOfDay convertStringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  String generateCarDeliveryTimesJson() {
    String result = "";
    List<DeliveryTimeCRUD> times = [];

    if (isGeneralTime.isTrue) {
      DeliveryTimeCRUD pazartesi = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Pazartesi", start: startTimes[7], end: endTimes[7]);
      DeliveryTimeCRUD sali = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Salı", start: startTimes[7], end: endTimes[7]);
      DeliveryTimeCRUD carsamba = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Çarşamba", start: startTimes[7], end: endTimes[7]);
      DeliveryTimeCRUD persembe = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Perşembe", start: startTimes[7], end: endTimes[7]);
      DeliveryTimeCRUD cuma = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Cuma", start: startTimes[7], end: endTimes[7]);
      DeliveryTimeCRUD cumartesi = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Cumartesi", start: startTimes[8], end: endTimes[8]);
      DeliveryTimeCRUD pazar = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Pazar", start: startTimes[8], end: endTimes[8]);
      times = [pazartesi, sali, carsamba, persembe, cuma, cumartesi, pazar];
    } else {
      DeliveryTimeCRUD pazartesi = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Pazartesi", start: startTimes[0], end: endTimes[0]);
      DeliveryTimeCRUD sali = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Salı", start: startTimes[1], end: endTimes[1]);
      DeliveryTimeCRUD carsamba = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Çarşamba", start: startTimes[2], end: endTimes[2]);
      DeliveryTimeCRUD persembe = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Perşembe", start: startTimes[3], end: endTimes[3]);
      DeliveryTimeCRUD cuma = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Cuma", start: startTimes[4], end: endTimes[4]);
      DeliveryTimeCRUD cumartesi = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Cumartesi", start: startTimes[5], end: endTimes[5]);
      DeliveryTimeCRUD pazar = DeliveryTimeCRUD(carID: carElement.carId!, deliveryTime: "Pazar", start: startTimes[6], end: endTimes[6]);
      times = [pazartesi, sali, carsamba, persembe, cuma, cumartesi, pazar];
    }

    result = jsonEncode(times);
    log(result);
    return result;
  }

  //CAR OWNER INFO

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<GeneralResponse> editUserInfo() async {
    String name = nameController.text;
    String surname = surnameController.text;
    String phone = phoneController.text;
    String email = emailController.text;

    Map<String, dynamic> saveUserInfoMap = {
      "car_id": carElement.carId,
      "user_name": name,
      "user_surname": surname,
      "user_phone": phone,
      "user_email": email,
    };

    GeneralResponse generalResponse = await ApiService.editUserInfo(saveUserInfoMap);

    return generalResponse;
  }

  //CarInfoEdit

  final carInfoEditKey = GlobalKey<FormState>();

  RxBool loadingBrands = false.obs;
  RxBool loadingModels = false.obs;
  RxList<BrandElement> carBrandsList = <BrandElement>[].obs;
  RxList<ModelElement> carModelList = <ModelElement>[].obs;

  String? carBrand, carModel, carYear, carFuel, carTransmission, carTypeText;
  int? carType;

  TextEditingController carPlate = TextEditingController();
  String? selectedKm;

  Future<void> changeCarType(value) async {
    carType = Lists.carTypeList.indexOf(value) + 1;
    carTypeText = Lists.carTypeList[carType! - 1];

    loadingBrands.value = true;
    loadingModels.value = true;

    carBrand = null;
    carModel = null;

    carBrandsList.clear();
    carModelList.clear();
    await fetchBrands(carType!);
  }

  Future<void> changeBrand(value) async {
    log(value, name: "value");
    carBrand = value;
    loadingModels.value = true;
    carModel = null;
    carModelList.clear();
    await fetchModels(int.parse(value));
  }

  Future<void> getCarEditInformations() async {
    if (carElement.carType! == 0) carElement.carType = 1;
    log(carElement.carType!.toString());
    carTypeText = Lists.carTypeList[carElement.carType! - 1];
    carType = carElement.carType;
    await fetchBrands(carType!);
    carBrand = getBrandName(carElement.brandName);
    await changeBrand(carBrand);
    carModel = getModelName(carElement.modelName);

    carYear = carElement.year.toString();
    carFuel = carElement.fuelType;
    carTransmission = carElement.transmissionType;

    carPlate.text = carElement.plate ?? "";
    selectedKm = carElement.km;
  }

  String getBrandName(value) => carBrandsList.firstWhere((element) => element.brandName == value).brandId.toString();
  String getModelName(value) => carModelList.firstWhere((element) => element.name == value).id.toString();

  Future<void> fetchBrands(int carType) async {
    try {
      carBrandsList.value = await ApiService.fetchBrands(carType);
    } catch (e, stackTrace) {
      log("Error fetching brands: $e\n$stackTrace");
    }
    loadingBrands.value = false;
  }

  Future<void> fetchModels(int brandId) async {
    try {
      carModelList.value = await ApiService.fetchModels(brandId, carType!);
    } catch (e) {
      log("Error fetching models: $e");
    }
    loadingModels.value = false;
  }

  Future<GeneralResponse> checkCarInfoAndSave() async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");
    if (carInfoEditKey.currentState!.validate()) {
      Map<String, dynamic> saveCarInfoMap = {
        "car_type": carType,
        "car_id": carElement.carId,
        "brand_id": int.parse(carBrand!),
        "model_id": int.parse(carModel!),
        "year": carYear,
        "fuel_type": carFuel,
        "transmission_type": carTransmission,
        "plate": carPlate.text,
        "km": selectedKm,
      };
      generalResponse = await ApiService.editCarInfo(saveCarInfoMap);
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli alanları doldurunuz.");
    }

    return generalResponse;
  }

  //DATE AND TIME EDIT
  final dateAndTimeEditKey = GlobalKey<FormState>();

  RxBool isGeneralTime = true.obs;

  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

  DateTime availableCarDateStart = DateTime.now();
  DateTime availableCarDateEnd = DateTime.now();

  TextEditingController availableCarDate = TextEditingController();

  List<TimeOfDay> startTimes = [
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now()
  ];
  List<TimeOfDay> endTimes = [
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now(),
    TimeOfDay.now()
  ];

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
    if (dateAndTimeEditKey.currentState!.validate()) {
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli alanları doldurunuz.");
    }
  }

  Future<GeneralResponse> editCarDeliveryTimes(int carId) async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");
    return generalResponse;
    /*
   
    List<String> weekDay = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma"];
    List<String> weekEndDay = ["Cumartesi", "Pazar"];

    Map<String, Map<String, TimeOfDay>> dayTimeMap = {
      "Pazartesi": {"start": availableMondayStartTime, "end": availableMondayEndTime},
      "Salı": {"start": availableTuesdayStartTime, "end": availableTuesdayEndTime},
      "Çarşamba": {"start": availableWednesdayStartTime, "end": availableWednesdayEndTime},
      "Perşembe": {"start": availableThursdayStartTime, "end": availableThursdayEndTime},
      "Cuma": {"start": availableFridayStartTime, "end": availableFridayEndTime},
      "Cumartesi": {"start": availableSaturdayStartTime, "end": availableSaturdayEndTime},
      "Pazar": {"start": availableSundayStartTime, "end": availableSundayStartTime},
    };

    if (isGeneralTime.value) {
      //For WeekDay
      for (int i = 0; i < weekDay.length; i++) {
        Map<String, dynamic> carAddDeliveryTime = {
          "car_id": carId,
          "delivery_type": weekDay[i],
          "start_time":
              "${availableWeekdayStartTime.hour.toString().padLeft(2, '0')}:${availableWeekdayStartTime.minute.toString().padLeft(2, '0')}:00.0000000",
          "end_time": "${availableWeekdayEndTime.hour.toString().padLeft(2, '0')}:${availableWeekdayEndTime.minute.toString().padLeft(2, '0')}:00.0000000",
        };

        log("CarId: ${carAddDeliveryTime["car_id"]}, DeliveryType: ${carAddDeliveryTime["delivery_type"]}, StartTime: ${carAddDeliveryTime["start_time"]}, EndTime: ${carAddDeliveryTime["end_time"]}");
        generalResponse = await ApiService.CarDerliveryTime(carAddDeliveryTime);
      }

      //For WeekEnd
      for (int i = 0; i < weekEndDay.length; i++) {
        Map<String, dynamic> carAddDeliveryTime = {
          "car_id": carId,
          "delivery_type": weekEndDay[i],
          "start_time":
              "${availableWeekEndStartTime.hour.toString().padLeft(2, '0')}:${availableWeekEndStartTime.minute.toString().padLeft(2, '0')}:00.0000000",
          "end_time": "${availableWeekEndEndTime.hour.toString().padLeft(2, '0')}:${availableWeekEndEndTime.minute.toString().padLeft(2, '0')}:00.0000000",
        };
        log("CarId: ${carAddDeliveryTime["car_id"]}, DeliveryType: ${carAddDeliveryTime["delivery_type"]}, StartTime: ${carAddDeliveryTime["start_time"]}, EndTime: ${carAddDeliveryTime["end_time"]}");

        generalResponse = await ApiService.CarDerliveryTime(carAddDeliveryTime);
        //log(generalResponse.message);
      }
      return generalResponse;
    } else {
      for (String day in dayTimeMap.keys) {
        Map<String, dynamic> carAddDeliveryTime = {
          "car_id": carId,
          "delivery_type": day,
          "start_time":
              "${dayTimeMap[day]!["start"]?.hour.toString().padLeft(2, '0')}:${availableWeekEndStartTime.minute.toString().padLeft(2, '0')}:00.0000000",
          "end_time": "${dayTimeMap[day]!["end"]?.hour.toString().padLeft(2, '0')}:${dayTimeMap[day]!["end"]?.minute.toString().padLeft(2, '0')}:00.0000000",
        };
        log("CarId: ${carAddDeliveryTime["car_id"]}, DeliveryType: ${carAddDeliveryTime["delivery_type"]}, StartTime: ${carAddDeliveryTime["start_time"]}, EndTime: ${carAddDeliveryTime["end_time"]}");

        generalResponse = await ApiService.CarDerliveryTime(carAddDeliveryTime);
        //log(generalResponse.message);
      }
      return generalResponse;
    }
    */
  }

  Future<GeneralResponse> editCarAvailableDate(int carId) async {
    Map<String, dynamic> carAddDeliveryTime = {
      "car_id": carId,
      "is_available_date_start": availableCarDateStart.toIso8601String(),
      "is_available_date_end": availableCarDateEnd.toIso8601String(),
    };

    GeneralResponse generalResponse = await ApiService.editCarAvailableDate(carAddDeliveryTime);
    log(generalResponse.message, name: "Date edited");
    return generalResponse;
  }

  //Locaitons

  RxList<CarAvailableLocation> locations = <CarAvailableLocation>[].obs;

  MapPickerController mapPickerController = MapPickerController();
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4192, 27.1287), zoom: 8.0);
  final googleMapController = Completer<GoogleMapController>();
  RxString gmAddressText = "".obs, rxCity = "".obs, rxDistrict = "".obs, address = "".obs;
  String district = "", city = "";

  void getLocations() {
    locations.value = carElement.carAvailableLocations!;
  }

  Future<bool> saveLocation(CarAvailableLocation carAvailableLocation) async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");

    try {
      Map<String, dynamic> carSaveLocationMap = {
        "car_id": carAvailableLocation.carId,
        "city": carAvailableLocation.city,
        "district": carAvailableLocation.district,
        "address": carAvailableLocation.address,
        "latitude": carAvailableLocation.latitude,
        "longitude": carAvailableLocation.longitude,
      };
      generalResponse = await ApiService.CarAddLocations(carSaveLocationMap);
      log(generalResponse.message);
      getLocations();

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> deleteLocation(int locationId) async {
    GeneralResponse generalResponse = await ApiService.DeleteLocation(locationId);
    log(generalResponse.message);
  }

  Future<void> openSelectLocationDialog() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // Konum iste iste
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 8.4746);
    }
    Get.dialog(const CarLocationEditSelectLocation());
  }

  //Photos

  RxList<EditCarUploadImage> carImages = <EditCarUploadImage>[
    EditCarUploadImage(
        header: "Aracın önden fotoğrafı",
        description: "Aracın önden fotoğrafını yükleyiniz.",
        ext: "",
        load: true.obs,
        photo64: "",
        isChanged: false.obs,
        path: "",
        photoType: 1),
    EditCarUploadImage(
        header: "Aracın arkadan fotoğrafı",
        description: "Aracın arkadan fotoğrafını yükleyiniz.",
        ext: "",
        load: true.obs,
        photo64: "",
        isChanged: false.obs,
        path: "",
        photoType: 2),
    EditCarUploadImage(
        header: "Aracın sağdan fotoğrafı",
        description: "Aracın sağ yandan fotoğrafını yükleyiniz.",
        ext: "",
        load: true.obs,
        photo64: "",
        isChanged: false.obs,
        path: "",
        photoType: 3),
    EditCarUploadImage(
        header: "Aracın soldan fotoğrafı",
        description: "Aracın sol yandan fotoğrafını yükleyiniz.",
        ext: "",
        load: true.obs,
        photo64: "",
        isChanged: false.obs,
        path: "",
        photoType: 4),
    EditCarUploadImage(
        header: "Araç içi ön kısım fotoğrafı",
        description: "Aracın araç iç ön kısmının fotoğrafını yükleyiniz.",
        ext: "",
        load: true.obs,
        photo64: "",
        isChanged: false.obs,
        path: "",
        photoType: 5),
    EditCarUploadImage(
        header: "Araç içi arka kısım fotoğrafı",
        description: "Aracın araç iç arka kısmının fotoğrafını yükleyiniz.",
        ext: "",
        load: true.obs,
        photo64: "",
        isChanged: false.obs,
        path: "",
        photoType: 6),
    EditCarUploadImage(
        header: "Araç bağaj fotoğrafı",
        description: "Aracın araç bagaj içi fotoğrafını yükleyiniz.",
        ext: "",
        load: true.obs,
        photo64: "",
        isChanged: false.obs,
        path: "",
        photoType: 7),
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
          carImages[index].isChanged.value = true;
        }
      }
    }
  }

  void removeImageAtIndex(int index) {
    carImages.value[index].load.value = false;
    carImages.value[index].ext = "";
    carImages.value[index].photo64 = "";
    carImages.value[index].isChanged.value = true;
  }

  Future<GeneralResponse> editCarPhotos() async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "Fotoğraflar kaydedilemedi");
    try {
      for (int i = 0; i < carImages.length; i++) {
        if (carImages[i].isChanged.value) {
          Map<String, dynamic> carAddPhotoMap = {
            "car_id": carElement.carId,
            "base64_image": carImages[i].photo64,
            "ext": carImages[i].ext,
            "photo_type": i + 1,
          };
          generalResponse = await ApiService.EditPhoto(carAddPhotoMap);
          return generalResponse;
        }
      }
      return generalResponse;
    } catch (e) {
      log(e.toString());
      return generalResponse;
    }
  }

  //Prices And Discounts

  Future<void> fillPriceAndDiscount() async {
    minRentDay.text = carElement.minRentDay.toString();
    dailyRentPrice.text = carElement.dailyPrice.toString();
    isLongTerm.value = carElement.isLongTerm == 1 ? true : false;
    weeklyDiscount = "%${carElement.weeklyRent}";
    monthlyDiscount = "%${carElement.monthlyRent}";
  }

  final pricesAndDiscountsKey = GlobalKey<FormState>();

  List<String> weeklyDiscountRateList = ['%0', '%5', '%10', "%20", "%30", "%40", "%50"];
  List<String> monthlyDiscountRateList = ['%0', '%5', '%10', "%20", "%30", "%40", "%50"];

  TextEditingController minRentDay = TextEditingController();

  String? weeklyDiscount, monthlyDiscount;

  TextEditingController dailyRentPrice = TextEditingController();

  RxBool isLongTerm = false.obs;

  String recomendation_price = "";

  Future<void> monthlyRentPriceCalculator() async {
    if (pricesAndDiscountsKey.currentState!.validate()) {
      double monthlyPrice = double.parse(dailyRentPrice.text.trim()) * 30;
      Get.dialog(AppCustomDialog(title: "Aylık Kira Ücreti", message: "${monthlyPrice.toStringAsFixed(2)} ₺"));
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli alanları doldurunuz.");
    }
  }

  Future<GeneralResponse> editPriceandDiscount() async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");
    if (pricesAndDiscountsKey.currentState!.validate()) {
      Map<String, dynamic> editPriceandDiscount = {
        "car_id": carElement.carId,
        "weekly_rent_discount": weeklyDiscount != null ? int.parse(weeklyDiscount!.replaceAll('%', '')) : 0,
        "monthly_rent_discount": monthlyDiscount != null ? int.parse(monthlyDiscount!.replaceAll('%', '')) : 0,
        "min_rent_day": int.parse(minRentDay.text),
        "daily_price": dailyRentPrice.text.toString(),
        "is_long_term": isLongTerm.value ? 1 : 0,
      };
      log(editPriceandDiscount["daily_price"]);

      GeneralResponse generalResponse = await ApiService.CarPriceEdit(editPriceandDiscount);
      return generalResponse;
    } else {
      return generalResponse;
    }
  }

  //Edit not

  TextEditingController note = TextEditingController();
  final notEditKey = GlobalKey<FormState>();

  Future<GeneralResponse> editNote() async {
    Map<String, dynamic> editNoteMap = {
      "car_id": carElement.carId,
      "note": note.text,
    };

    GeneralResponse generalResponse = await ApiService.CarNoteEdit(editNoteMap);
    log(generalResponse.message, name: "Not edited");
    return generalResponse;
  }

  //Active And Delete Car

  RxInt isActive = 0.obs;
  RxInt isApproved = 0.obs;

  Future<GeneralResponse> changeActivity() async {
    if (isActive.value == 0) {
      isActive.value = 1;
    } else {
      isActive.value = 0;
    }
    Map<String, dynamic> activityMap = {
      "car_id": carElement.carId,
      "is_active": isActive.value,
    };

    GeneralResponse generalResponse = await ApiService.EditActivity(activityMap);
    log(generalResponse.message, name: "Activity edited");

    return generalResponse;
  }

  Future<GeneralResponse> DeleteCar() async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "Aracınız silinemedi!");
    generalResponse = await ApiService.DeleteCar(carElement.carId);
    log(generalResponse.message);
    return generalResponse;
  }
}

class EditCarUploadImage {
  String path;
  RxBool load;
  String header;
  String description;
  String photo64;
  String ext;
  RxBool isChanged;
  int photoType;

  EditCarUploadImage(
      {required this.description,
      required this.ext,
      required this.header,
      required this.load,
      required this.photo64,
      required this.isChanged,
      required this.path,
      required this.photoType});
}

class DeliveryTimeCRUD {
  int carID;
  String deliveryTime;
  TimeOfDay start;
  TimeOfDay end;

  DeliveryTimeCRUD({required this.carID, required this.deliveryTime, required this.start, required this.end});

  Map<String, dynamic> toJson() => {"carID": carID, "deliveryTime": deliveryTime, "start": getTimeString(start), "end": getTimeString(end)};
}

String getTimeString(TimeOfDay time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
