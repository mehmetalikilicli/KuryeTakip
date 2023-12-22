// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'dart:developer';

import 'package:get/get.dart';
import 'package:kurye_takip/model/car_item.dart';
import 'package:kurye_takip/service/api_service.dart';
import 'package:kurye_takip/service/banner_service.dart';

class CarController extends GetxController {
  List<CarItem> cars = [];
  List<String> bannerUrls = [];
  RxList<CarItem> filteredCars = <CarItem>[].obs;

  RxInt activeType = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    fetchBanner();
  }

  Future<void> fetchData() async {
    try {
      cars = await CarService.fetchCars();
      filter(activeType.value);
      //await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      print('Error: $e');
    }
  }

  void filter(int id) {
    activeType.value = id;
    List<CarItem> filtered = cars.where((element) => element.type == id).toList();
    filteredCars.value = filtered;
  }

  Future<void> fetchBanner() async {
    try {
      bannerUrls = await BannerService.fetchBannerUrls();
    } catch (e) {
      print('Error fetching banner: $e');
    }
  }
}
