// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurye_takip/helpers/helpers.dart';

class TestRegisterView extends StatelessWidget {
  TestRegisterView({super.key});

  Uint8List compressed = Uint8List(0);
  Uint8List original = Uint8List(0);

  RxBool showImages = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Kayıt Ol"),
              const SizedBox(height: kToolbarHeight),
              MaterialButton(
                onPressed: () async {
                  showImages.value = false;

                  final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (image.isNull == false) {
                    String ext = image!.path.split(".").last;
                    final bytes = await image.readAsBytes();
                    original = bytes;
                    log(bytes.lengthInBytes.toString(), name: "Image length");
                    log((bytes.lengthInBytes / 1024).toStringAsFixed(2), name: "Image Kb");

                    var result = await FlutterImageCompress.compressWithList(bytes,
                        minWidth: 720, minHeight: 480, quality: 50, rotate: 0);
                    compressed = result;
                    log(result.lengthInBytes.toString(), name: "Image length compressed");
                    log((result.lengthInBytes / 1024).toStringAsFixed(2), name: "Image Kb");

                    final byteLength = result.lengthInBytes;
                    final kByte = byteLength / 1024;
                    final mByte = kByte / 1024;
                    if (mByte > 2.5) {
                      log("Maksimum boyut 2.5 mb olabilir.");
                    } else {
                      String body = json.encode({
                        "Extension": ext,
                        "PhotoBase64": base64.encode(result),
                      });
                      log(body, name: "Image Json Example");
                      showImages.value = true;
                    }
                  } else {}
                },
                child: const Text("Ehliyet Fotoğrafı Yükle"),
              ),
              Obx(
                () => Visibility(
                  visible: showImages.isTrue,
                  child: Column(
                    children: [
                      const Text("Original Image"),
                      Image.memory(original, width: Get.width, fit: BoxFit.contain),
                      const SizedBox(height: 8),
                      const Text("Compressed Image"),
                      Image.memory(compressed, width: Get.width, fit: BoxFit.contain),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  bool is_vehicle_owner = false;

  //Driving License
  TextEditingController dl_number = TextEditingController();
  TextEditingController dl_date_input = TextEditingController();
  DateTime dl_date = DateTime.now();
  String dl_front_image = "";
  String dl_front_extension = "";
  String dl_back_image = "";
  String dl_back_extension = "";

  String createVehicleOwnerRegisterBody() {
    String jsonBody = jsonEncode({
      "name": name.text.trim(),
      "mail": mail.text.trim(),
      "phone": phone.text.trim(),
      "password": Helpers.encryptPassword(password.text.trim()),
      "is_vehicle_owner": is_vehicle_owner,
    });
    return jsonBody;
  }

  String createRenterRegisterBody() {
    String jsonBody = jsonEncode({
      "name": name.text.trim(),
      "mail": mail.text.trim(),
      "phone": phone.text.trim(),
      "password": Helpers.encryptPassword(password.text.trim()),
      "is_vehicle_owner": is_vehicle_owner,
      "dl_front_image": dl_front_image,
      "dl_front_image_extension": dl_back_extension,
      "dl_back_image": dl_front_image,
      "dl_back_image_extension": dl_back_extension,
      "dl_date": dl_date_input.text.trim(),
      "dl_number": dl_number.text.trim(),
      "city": "Kayseri",
      "district": "Melikgazi",
      "address": "Erciyes Teknopark"
    });
    return jsonBody;
  }
}


// Form Validation
// TextField => TextFormField
// Column? ListView ? SingleVhildScrolllView? => SingleChild Kullan List view hata verebiliyor.
// SingleChildScrooll içindeki column wrap wit Form(),
// Form => key ksımı var kullanılacak araştır.
// Butona basınca key ile validate yapılacak.

// İnputları validate eder sadece image yüklenip yüklenmediğini sen edecen

