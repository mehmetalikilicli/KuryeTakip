// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/rent_request_notification.dart';
import 'package:kurye_takip/pages/payment/payment_controller.dart';

class PaymentPage extends StatelessWidget {
  PaymentPage({super.key, required this.carElement, required this.rentNotification});

  RentNotification rentNotification;
  CarElement carElement;

  PaymentController controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: OutlinedButton(
        style: const ButtonStyle(),
        child: Text(rentNotification.paymentStatus == 0 ? "Ücreti Ödeyiniz" : "Ücretiniz Ödendi Fotoğrafları Yükleyebilirsiniz."),
        onPressed: () {
          controller.payPrice(rentNotification.ID);
        },
      )),
    );
  }
}
