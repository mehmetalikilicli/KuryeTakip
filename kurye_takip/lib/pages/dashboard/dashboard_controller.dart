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

  String? carFuel, carTransmission;

  TextEditingController minRentDay = TextEditingController();

  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();

  RxBool filterIsLongTerm = true.obs;
  RxBool filterIsShortTerm = true.obs;

  RxBool isDateCloseIconShow = false.obs;

  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4237, 27.1428), zoom: 8);
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
  void onInit() async {
    super.onInit();
    await fetchBanner();
    await fetchData();
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
      log(cars.cars.length.toString());
      //await Future.delayed(const Duration(seconds: 2));
      clearFilters();
      await fetchBrands();
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
    List<CarElement> filtered = cars.cars.where((car) {
      DateTime? carStartDate = car.is_available_date_start;
      DateTime? carEndDate = car.is_available_date_end;

      int minRentDay = car.minRentDay ?? 0;

      bool carTypeFilter = car.carType == selectedType.value;
      bool fuelTypeFilter = carFuel == null || car.fuelType == carFuel || carFuel == 'Tümü';
      bool transmissionTypeFilter = carTransmission == null || car.transmissionType == carTransmission || carTransmission == 'Tümü';
      bool minPriceFilter = minPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! >= int.parse(minPrice.text));
      bool maxPriceFilter = maxPrice.text.isEmpty || (car.dailyPrice != null && car.dailyPrice! <= int.parse(maxPrice.text));

      bool brandFilter = carBrand == null || car.brandId.toString() == carBrand;
      //log(brandFilter.toString());
      bool modelFilter = carModel == null || car.modelId.toString() == carModel;

      // Tarih aralığı kontrolü
      bool dateRangeFilter = carStartDate!.isBefore(filterDateStart.add(const Duration(days: 1))) && carEndDate!.isAfter(filterDateEnd);

      // minRentDay ile tarih arasındaki fark
      //bool minRentDayFilter = dayDifference >= minRentDay;

      return carTypeFilter &&
          dateRangeFilter &&
          fuelTypeFilter &&
          transmissionTypeFilter &&
          minPriceFilter &&
          maxPriceFilter &&
          brandFilter &&
          modelFilter; // &&
      //minRentDayFilter;
    }).toList();

    filteredCars.assignAll(filtered);
  }

  void dateChanged(DateTimeRange result) {
    filterDateStart = result.start;
    filterDateEnd = result.end;
    filterDateText.text = "${DateFormat('dd.MM.yyyy').format(result.start)} - ${DateFormat('dd.MM.yyyy').format(result.end)}";
    isDateCloseIconShow.value = true;
    applyFilters();
  }

  Future<void> changeCarType(int carType) async {
    carBrandsList.clear();
    carModelList.clear();

    carBrand = null;
    carModel = null;

    selectedType.value = carType;

    await fetchData();
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

    applyFilters();
  }

  void clearDate() {
    isDateCloseIconShow.value = false;
    filterDateText.text = "";
    filterDateStart = DateTime.now();
    filterDateEnd = DateTime.now();
    applyFilters();
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

  String getBrandName(brandName) => carBrandsList.firstWhere((element) => element.brandName == brandName).brandId.toString();
  String getModelName(modelName) => carModelList.firstWhere((element) => element.name == modelName).id.toString();
}
