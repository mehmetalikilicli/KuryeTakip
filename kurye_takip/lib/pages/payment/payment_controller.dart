import 'dart:developer';

import 'package:get/get.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/service/api_service.dart';

class PaymentController extends GetxController {
  Future<void> payPrice(int notificationId) async {
    GeneralResponse generalResponse = await ApiService.PayPrice(notificationId);
    log(generalResponse.message);
  }
}
