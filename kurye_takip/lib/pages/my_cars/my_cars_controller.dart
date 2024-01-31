// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:kurye_takip/helpers/get_local_user_id.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/service/api_service.dart';

class MyCarsController extends GetxController {
  Cars cars = Cars(success: false, message: "", cars: []);

  Future<void> fetchData() async {
    try {
      cars = await ApiService.fetchMyCars(getLocalUserID());
    } catch (e) {
      print('Error: $e');
    }
  }
}
