// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:kurye_takip/helpers/get_local_user.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/service/api_service.dart';

class MyCarsController extends GetxController {
  RxList<CarElement> carList = <CarElement>[].obs;

  RxInt isActive = 0.obs;

  Future<void> fetchData() async {
    try {
      Cars cars = await ApiService.fetchMyCars(
        GetLocalUserInfo.getLocalUserID(),
      );
      carList.value = cars.cars;
    } catch (e) {
      print('Error: $e');
    }
  }
}
