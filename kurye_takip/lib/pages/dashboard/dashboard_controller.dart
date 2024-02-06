// ignore_for_file: invalid_use_of_protected_member, avoid_print, unused_local_variable, unused_element

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/model/brand.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/model.dart';
import 'package:kurye_takip/service/api_service.dart';
import 'package:kurye_takip/service/banner_service.dart';

class DashboardController extends GetxController {
  Cars cars = Cars(success: false, message: "", cars: []);
  List<String> bannerUrls = [];
  RxList<CarElement> filteredCars = <CarElement>[].obs;

  //RxList<int> selectedTypes = <int>[].obs;
  RxInt selectedType = 1.obs;

  TextEditingController filterDateText = TextEditingController();
  DateTime filterDateStart = DateTime.now();
  DateTime filterDateEnd = DateTime.now();

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

  RxList<BrandElement> carBrandsList = <BrandElement>[].obs;
  RxList<ModelElement> carModelList = <ModelElement>[].obs;

  String? carBrand, carModel;

  RxBool loadingModels = false.obs;
  RxBool loadingBrands = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanner();
    fetchData();
  }

  void changeBrand(value) {
    carModel = null;
    carModelList.clear();
    carBrand = value;
    loadingModels.value = true;
    carModel = null;
    fetchModels(int.parse(value));
  }

  Future<void> fetchModels(int brandId) async {
    try {
      List<ModelElement> modelList = await ApiService.fetchModels(brandId, selectedType.value);
      carModelList.assignAll(modelList);
    } catch (e) {
      log("Error fetching models: $e");
    }
    loadingModels.value = false;
  }

  Future<void> fetchData() async {
    try {
      cars = await ApiService.fetchCars();
      //await Future.delayed(const Duration(seconds: 2));
      clearFilters();
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
      DateTime? carStartDate = car.is_available_date_start;
      DateTime? carEndDate = car.is_available_date_end;

      // Filtrelerin kontrolü
      bool fuelTypeFilter = carFuel == null || car.fuelType == carFuel;
      bool transmissionTypeFilter = carTransmission == null || car.transmissionType == carTransmission;
      bool minRentDayFilter = minRentDay.text.isEmpty || (car.minRentDay != null && car.minRentDay! >= int.parse(minRentDay.text));
      bool minPriceFilter = minPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! >= int.parse(minPrice.text));
      bool maxPriceFilter = maxPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! <= int.parse(maxPrice.text));
      bool brandFilter = carBrand == null || car.brandName == carBrand;
      bool modelFilter = carModel == null || car.modelName == carModel;

      // Sadece seçili carType'a göre filtreleme
      bool carTypeFilter = car.carType == selectedType.value;

      // Tüm filtrelerin kontrolü
      return carTypeFilter && fuelTypeFilter && transmissionTypeFilter && minRentDayFilter && minPriceFilter && maxPriceFilter && brandFilter && modelFilter;
    }).toList();

    // Filtrelenmiş araçları atama
    filteredCars.assignAll(filtered);
  }

  Future<void> toggleCarType(int id) async {
    carBrandsList.clear();
    carModelList.clear();

    carBrand = null;
    carModel = null;

    selectedType.value = id;

    await fetchBrands();

    applyFilters();
  }

  Future<void> fetchBrands() async {
    carBrandsList.clear();
    try {
      List<BrandElement> brandList = await ApiService.fetchBrands(selectedType.value);
      carBrandsList.addAll(brandList);
    } catch (e) {
      log("Error fetching brands: $e");
    }
  }

  void clearFilters() {
    selectedType.value = 1;
    carFuel = null;
    carTransmission = null;
    carBrandsList.clear();
    carModelList.clear();
    carBrand = null;
    carModel = null;
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
