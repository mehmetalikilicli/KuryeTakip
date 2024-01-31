// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/service/api_service.dart';
import 'package:kurye_takip/service/banner_service.dart';

class DashboardController extends GetxController {
  Cars cars = Cars(success: false, message: "", cars: []);
  List<String> bannerUrls = [];
  RxList<CarElement> filteredCars = <CarElement>[].obs;

  RxList<int> selectedTypes = <int>[].obs;

  TextEditingController filterDateText = TextEditingController();
  DateTime filterDateStart = DateTime.now();
  DateTime filterDateEnd = DateTime.now();

  List<String> carYearList = ['2020', '2021', '2022', "2023", "2024"];
  List<String> carFuelTypeList = ['Hybrid', 'Benzin', 'Dizel'];
  List<String> carTransmissionTypeList = ['Otomatik', 'Manuel', 'Yarı Otomatik'];

  String? carYear, carFuel, carTransmission;

  TextEditingController minRentDay = TextEditingController();

  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();

  RxBool filterIsLongTerm = true.obs;
  RxBool filterIsShortTerm = true.obs;

  final List<String> bannerSvgAssets = [
    'assets/svgs/banner1.svg',
    'assets/svgs/banner2.svg',
    'assets/svgs/banner3.svg',
    'assets/svgs/banner4.svg',
    'assets/svgs/banner5.svg',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchBanner();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      cars = await ApiService.fetchCars();
      //await Future.delayed(const Duration(seconds: 2));
      applyFilters();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchBanner() async {
    try {
      bannerUrls = await BannerService.fetchBannerUrls();
    } catch (e) {
      print('Error fetching banner: $e');
    }
  }

  Future<void> applyFilters() async {
    DateTime selectedStartDate = filterDateStart;
    DateTime selectedEndDate = filterDateEnd.add(const Duration(days: 1));

    List<CarElement> filtered = cars.cars.where((car) {
      DateTime carStartDate = car.is_available_date_start ?? DateTime.now();
      DateTime carEndDate = car.is_available_date_end ?? DateTime.now();

      bool isCarTypeSelected = selectedTypes.isEmpty || selectedTypes.contains(car.carType);

      bool isLongTermSelected = filterIsLongTerm.value;
      bool isShortTermSelected = filterIsShortTerm.value;

      // Veritabanında kullanılan isLongTerm değerine göre filtreleme
      bool isCarLongTerm = car.isLongTerm == 1;

      return carStartDate.isAfter(selectedStartDate) &&
          carEndDate.isBefore(selectedEndDate) &&
          isCarTypeSelected &&
          (carFuel == null || car.fuelType == carFuel) &&
          (carTransmission == null || car.transmissionType == carTransmission) &&
          (minRentDay.text.isEmpty || (car.minRentDay != null && car.minRentDay! >= int.parse(minRentDay.text))) &&
          (minPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! >= int.parse(minPrice.text))) &&
          (maxPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! <= int.parse(maxPrice.text))) &&
          ((isLongTermSelected && isCarLongTerm) ||
              (isShortTermSelected && !isCarLongTerm) ||
              (isLongTermSelected && isShortTermSelected) ||
              (!isLongTermSelected && !isShortTermSelected));
    }).toList();

    //log('Filtered Cars: $filtered');
    //log('Filtered Cars length: ${filtered.length}');

    filteredCars.assignAll(filtered);
  }

  void toggleCarType(int id) {
    if (selectedTypes.contains(id)) {
      selectedTypes.remove(id);
    } else {
      selectedTypes.add(id);
    }
    applyFilters();
  }

  void clearFilters() {
    selectedTypes.clear();
    carFuel = null;
    carTransmission = null;
    minRentDay.clear();
    minPrice.clear();
    maxPrice.clear();
    filterDateText.text = "";
    filterIsLongTerm.value = true;
    filterIsShortTerm.value = true;
    filterDateStart = DateTime.now();
    filterDateEnd = DateTime.now();

    clearAndAddAllCars();
  }

  void clearAndAddAllCars() {
    filteredCars.clear();
    filteredCars.addAll(cars.cars);
  }

  void clearDate() {
    filterDateText.text = "";
    filterDateStart = DateTime.now();
    filterDateEnd = DateTime.now();
  }
}
