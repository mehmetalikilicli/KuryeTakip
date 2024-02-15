// ignore_for_file: invalid_use_of_protected_member, avoid_print, unused_local_variable, unused_element, prefer_collection_literals, non_constant_identifier_names

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/model/brand.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/model.dart';
import 'package:kurye_takip/pages/cars_detail/car_detail.dart';
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

  RxBool isDateCloseIconShow = false.obs;

  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4237, 27.1428), zoom: 10);
  Set<Marker> carsMarkers = Set<Marker>();
  final googleMapController = Completer<GoogleMapController>();

  final List<String> bannerSvgAssets2 = [
    'assets/pngs/banner1.png',
    'assets/pngs/banner2.png',
    'assets/pngs/banner3.png',
    'assets/pngs/banner4.png',
    'assets/pngs/banner5.png',
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

  /*Future<void> applyFilters() async {
    DateTime selectedStartDate = filterDateStart;
    DateTime selectedEndDate = filterDateEnd.add(const Duration(days: 1));

    List<CarElement> filtered = cars.cars.where((car) {
      DateTime? carStartDate = car.is_available_date_start;
      DateTime? carEndDate = car.is_available_date_end;

      // Filtrelerin kontrolü
      bool fuelTypeFilter = carFuel == null || car.fuelType == carFuel;
      //bool transmissionTypeFilter = carTransmission == null || car.transmissionType == carTransmission;
      //bool minRentDayFilter = minRentDay.text.isEmpty || (car.minRentDay != null && car.minRentDay! >= int.parse(minRentDay.text));
      //bool minPriceFilter = minPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! >= int.parse(minPrice.text));
      //bool maxPriceFilter = maxPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! <= int.parse(maxPrice.text));
      //bool brandFilter = carBrand == null || car.brandName == carBrand;
      //bool modelFilter = carModel == null || car.modelName == carModel;

      // Sadece seçili carType'a göre filtreleme
      bool carTypeFilter = car.carType == selectedType.value;

      // Tüm filtrelerin kontrolü
      return carTypeFilter && fuelTypeFilter; //&& transmissionTypeFilter && minPriceFilter && maxPriceFilter && brandFilter && modelFilter;
    }).toList();

    // Filtrelenmiş araçları atama
    filteredCars.assignAll(filtered);
  }*/

  Future<void> applyFilters2() async {
    DateTime selectedStartDate = filterDateStart;
    DateTime selectedEndDate = filterDateEnd.add(const Duration(days: 1));

    List<CarElement> filtered = cars.cars.where((car) {
      DateTime? carStartDate = car.is_available_date_start;
      DateTime? carEndDate = car.is_available_date_end;

      int minRentDay = car.minRentDay!;

      bool carTypeFilter = car.carType == selectedType.value;
      bool fuelTypeFilter = carFuel == null || car.fuelType == carFuel || carTransmission == 'Tümü';
      bool transmissionTypeFilter = carTransmission == null || car.transmissionType == carTransmission;
      bool minPriceFilter = minPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! >= int.parse(minPrice.text));
      bool maxPriceFilter = maxPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! <= int.parse(maxPrice.text));

      bool brandFilter = carBrand == null || car.brandName == carBrand;
      bool modelFilter = carModel == null || car.modelName == carModel;

      int dayDifference = carStartDate!.difference(carEndDate!).inDays.abs();

      //log(dayDifference.toString());
      //log(minRentDay.toString());
      //log(carStartDate.toString(), name: "carStartDate ");
      //log(carEndDate.toString(), name: "carEndDate   ");
      //log("----------------------");

      return carTypeFilter &&
          carStartDate.isBefore(selectedEndDate) &&
          carEndDate.isAfter(selectedStartDate) &&
          fuelTypeFilter &&
          transmissionTypeFilter &&
          minPriceFilter &&
          maxPriceFilter &&
          brandFilter &&
          modelFilter &&
          dayDifference >= minRentDay;
    }).toList();

    // Filtrelenmiş araçları atama
    filteredCars.assignAll(filtered);
    //log(filteredCars.length.toString(), name: "filteredCars length");
  }

  void dateChanged(DateTimeRange result) {
    filterDateStart = result.start;
    filterDateEnd = result.end;
    filterDateText.text = "${DateFormat('dd.MM.yyyy').format(result.start)} - ${DateFormat('dd.MM.yyyy').format(result.end)}";
    isDateCloseIconShow.value = true;
    applyFilters2();
  }

  Future<void> toggleCarType(int id) async {
    carBrandsList.clear();
    carModelList.clear();

    carBrand = null;
    carModel = null;

    selectedType.value = id;

    await fetchBrands();

    applyFilters2();
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

    applyFilters2();
  }

  Future<void> applyFiltersByWithoutDates() async {
    List<CarElement> filtered = cars.cars.where((car) {
      int minRentDay = car.minRentDay!;

      bool carTypeFilter = car.carType == selectedType.value;
      bool fuelTypeFilter = carFuel == null || car.fuelType == carFuel || carTransmission == 'Tümü';
      bool transmissionTypeFilter = carTransmission == null || car.transmissionType == carTransmission;
      bool minPriceFilter = minPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! >= int.parse(minPrice.text));
      bool maxPriceFilter = maxPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! <= int.parse(maxPrice.text));

      bool brandFilter = carBrand == null || car.brandName == carBrand;
      bool modelFilter = carModel == null || car.modelName == carModel;

      //log(minRentDay.toString());
      //log("----------------------");

      return carTypeFilter && fuelTypeFilter && transmissionTypeFilter && minPriceFilter && maxPriceFilter && brandFilter && modelFilter;
    }).toList();

    // Filtrelenmiş araçları atama
    filteredCars.assignAll(filtered);
    //log(filteredCars.length.toString(), name: "filteredCars length");
  }

  void clearDate() {
    isDateCloseIconShow.value = false;
    filterDateText.text = "";
    filterDateStart = DateTime.now();
    filterDateEnd = DateTime.now();
    applyFiltersByWithoutDates();
  }

  Set<Marker> FillTheMarkers(List<CarElement> cars) {
    for (var car in cars) {
      for (var location in car.carAvailableLocations!) {
        Marker marker = Marker(
          markerId: MarkerId(location.id.toString()),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
              title: '${car.brandName} - ${car.modelName}',
              snippet: 'Fiyat: ${car.dailyPrice.toString()}',
              onTap: () {
                Get.to(CarDetailView(
                  carElement: car,
                  isfloatingActionButtonActive: true,
                  isAppBarActive: true,
                ));
              }),
        );
        carsMarkers.add(marker);
      }
    }

    return carsMarkers;
  }
}
