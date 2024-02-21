// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/components/my_samples.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/rent_request_notification.dart';
import 'package:kurye_takip/pages/payment/payment_controller.dart';
import 'package:kurye_takip/pages/widgets/inputs.dart';

class PaymentPage extends StatelessWidget {
  PaymentPage({super.key, required this.carElement, required this.rentNotification});

  RentNotification rentNotification;
  CarElement carElement;

  PaymentController controller = Get.put(PaymentController());

  @override
  void initState() {
    controller.carElement = carElement;
    controller.rentNotification = rentNotification;

    controller.paymentStatus.value = rentNotification.paymentStatus!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ödeme"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.paymentForm,
            child: Column(
              children: [
                Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Add padding around the row widget
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Kiralama gün sayısı", style: MyTextSample.subtitle(context)),
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(rentNotification.rentStartDate.difference(rentNotification.rentEndDate).inDays.abs().toString(),
                                            style: MyTextSample.body1(context)!),
                                      ),
                                      const SizedBox(height: 8),
                                      Text("Günlük kira bedeli", style: MyTextSample.subtitle(context)),
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(rentNotification.price.toString(), style: MyTextSample.body1(context)!),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                          child: Text("Kart Üzerindeki İsim", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        TextFormField(
                          enabled: true,
                          controller: controller.name,
                          keyboardType: TextInputType.name,
                          decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Kart Üzerindeki İsim", Icons.add_card_rounded, Colors.black),
                          validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                          child: Text("Kart Numarası", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        TextFormField(
                          enabled: true,
                          controller: controller.cardNumber,
                          keyboardType: TextInputType.number,
                          decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Kart Numarası", CupertinoIcons.creditcard, Colors.black),
                          validator: (value) => value!.isEmpty
                              ? "Boş bırakılamaz"
                              : value.length != 19
                                  ? "Kartınızın 16 haneli numarasını giriniz"
                                  : null,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16), // En fazla 16 karakter
                            _CardNumberInputFormatter(), // 4'er 4'er gruplama için özel input formatter
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                                    child: Text("Son Kullanma Tarihi", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  TextFormField(
                                    enabled: true,
                                    controller: controller.cardExpireDate,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [CardExpirationDateInputFormatter()],
                                    decoration: InputWidgets().dropdownDecoration(
                                        Colors.grey, Colors.red, "Son Kullanma Tarihi (MM/YY)", CupertinoIcons.calendar_today, Colors.black),
                                    validator: (value) => value!.isEmpty
                                        ? "Boş bırakılamaz"
                                        : value.length != 5
                                            ? "SKT giriniz"
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                                    child: Text("CVV", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  TextFormField(
                                    enabled: true,
                                    controller: controller.cardCVV,
                                    keyboardType: TextInputType.number,
                                    decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "CVV", CupertinoIcons.number, Colors.black),
                                    validator: (value) => value!.isEmpty
                                        ? "Boş bırakılamaz"
                                        : value.length != 3
                                            ? "CVV giriniz"
                                            : null,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 24.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      style: const ButtonStyle(),
                      child: Obx(() {
                        return Text(controller.paymentStatus == 0 ? "Ödeme Yap" : "Ücretiniz Ödendi Fotoğrafları Yükleyebilirsiniz.");
                      }),
                      onPressed: () {
                        if (controller.paymentForm.currentState!.validate()) {
                          controller.payPrice(rentNotification.ID);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\s'), ''); // Boşlukları kaldır
    var maskedText = '';
    for (var i = 0; i < newText.length; i++) {
      maskedText += newText[i];
      if ((i + 1) % 4 == 0 && i != newText.length - 1) {
        maskedText += ' '; // Her 4 karakterden sonra boşluk ekle
      }
    }
    return newValue.copyWith(
      text: maskedText,
      selection: TextSelection.collapsed(offset: maskedText.length),
    );
  }
}

class CardExpirationDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), ''); // Sadece rakamları al
    if (newText.isEmpty) return TextEditingValue.empty;

    var text = newText;
    if (text.length > 4) {
      text = text.substring(0, 4); // Metni en fazla 4 karaktere kırp
    }
    if (text.length > 2) {
      text = '${text.substring(0, 2)}/${text.substring(2)}'; // Ay ve yılı / ile ayır
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
