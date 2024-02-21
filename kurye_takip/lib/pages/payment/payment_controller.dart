import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/model/rent_request_notification.dart';
import 'package:kurye_takip/service/api_service.dart';

class PaymentController extends GetxController {
  RentNotification? rentNotification;
  CarElement? carElement;

  RxInt paymentStatus = 0.obs;

  final paymentForm = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardExpireDate = TextEditingController();
  TextEditingController cardCVV = TextEditingController();

  String cardNumberClear = "";

  Future<void> payPrice(int notificationId) async {
    GeneralResponse generalResponse = await ApiService.PayPrice(notificationId);
    log(generalResponse.message);

    cardNumberClear = cardNumber.text.replaceAll(' ', '');

    String cardExpireDateClear = cardExpireDate.text;
    List<String> parts = cardExpireDateClear.split('/');
    String cardMonth = parts[0];
    String cardYear = parts[1];

    log(cardNumberClear, name: "Card Number");
    log(cardYear, name: "Card Year");
    log(cardMonth, name: "Card Month");
    log(cardCVV.text, name: "Card CVV");

    //if (generalResponse.success) {
    //  paymentStatus.value = 1;
    //}

    //log(generalResponse.message);
  }

  void calculateDayDifference() {}
}
