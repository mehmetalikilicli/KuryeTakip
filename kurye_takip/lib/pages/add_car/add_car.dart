import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/helpers/take_image.dart';
import 'package:kurye_takip/model/brand.dart';
import 'package:kurye_takip/model/model.dart';
import 'package:kurye_takip/pages/add_car/add_car_controller.dart';
import 'package:map_picker/map_picker.dart';

class AddCarPage extends StatelessWidget {
  AddCarPage({super.key});

  final AddCarController controller = Get.put(AddCarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ARAÇ EKLEME"),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.addCarPageController,
        children: [
          //carAddPage1(controller: controller),
          carAddPage2(),
          //carAddPage3(controller: controller),
          //carAddPage4(controller: controller),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.addCarFormKey5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Text("Aracın Önden Fotoğrafını yükleyiniz.", style: TextStyle(fontSize: 16)),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    title: Text("Fotoğraf Yükle"),
                                    children: [
                                      // Kamera
                                      SimpleDialogOption(
                                        onPressed: () async {
                                          final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                                          if (image != null) {
                                            final bytes = await image.readAsBytes();
                                            var result =
                                                await FlutterImageCompress.compressWithList(bytes, minWidth: 720, minHeight: 480, quality: 50, rotate: 0);
                                            final byteLength = result.lengthInBytes;
                                            final kByte = byteLength / 1024;
                                            final mByte = kByte / 1024;
                                            if (mByte > 2.5) {
                                              log("Maksimum boyut 2.5 MB olabilir.");
                                            } else {
                                              controller.image1 = base64.encode(result);
                                              controller.image1ext = image.path.split(".").last;
                                            }
                                          } else {
                                            log("Kullanıcı kamera ile fotoğraf seçmedi.");
                                          }
                                        },
                                        child: Text("Kamera"),
                                      ),

                                      // Kamera Deneme
                                      SimpleDialogOption(
                                        onPressed: () async {
                                          var result = await captureAndCompressImage(context);
                                          if (result != null) {
                                            // Elde edilen sıkıştırılmış fotoğraf bilgisini kullanın
                                            print("Image Data: ${result.imageData}");
                                            print("Image Extension: ${result.imageExtension}");

                                            // Çerçeve içinde fotoğrafı göster
                                            Navigator.pop(context);
                                            //showImageDialog(context, base64Image: result.imageData);
                                          }
                                        },
                                        child: Text("Galeri"),
                                      ),

                                      // Galeri
                                      SimpleDialogOption(
                                        onPressed: () async {
                                          final imagePicker = ImagePicker();
                                          final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                                          if (pickedFile != null) {
                                            // Seçilen fotoğrafı işle
                                            // ...
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Text("Galeri"),
                                      ),

                                      // Fotoğrafı kaldır
                                      SimpleDialogOption(
                                        onPressed: () {
                                          // Fotoğrafı kaldır işlemleri
                                          // ...
                                          Navigator.pop(context);
                                        },
                                        child: Text("Fotoğrafı Kaldır"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: Get.width * 0.4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (controller.image1 != null)
                                    Image.memory(base64Decode(controller.image1), fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                                    child: Icon(Icons.add, color: Colors.white, size: 30),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: MaterialButton(
                              color: AppColors.primaryColor,
                              minWidth: Get.width / 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              onPressed: () {
                                controller.addCarPageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                              },
                              child: const Text("Geri", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: MaterialButton(
                              color: AppColors.primaryColor,
                              minWidth: Get.width / 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              onPressed: () {
                                controller.addCarPageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                              },
                              child: const Text("İleri", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SafeArea carAddPage2() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.addCarFormKey2,
            child: Column(
              children: [
                //Name
                TextFormField(
                  enabled: true,
                  controller: controller.rentName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    label: Text("İsim"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                  ),
                  validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                ),
                const SizedBox(height: 8),
                //Surname
                TextFormField(
                  enabled: true,
                  controller: controller.rentSurname,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    label: Text("Soyisim"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                  ),
                  validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                ),
                const SizedBox(height: 8),
                //Phone
                TextFormField(
                  controller: controller.rentPhone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    label: Text("Telefon"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: Icon(Icons.person, color: const Color.fromARGB(255, 152, 176, 190)),
                  ),
                  validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                ),
                const SizedBox(height: 8),
                //Email
                TextFormField(
                  controller: controller.rentMail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text("Eposta"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                  ),
                  validator: (value) => value!.isEmpty
                      ? "Boş bırakılamaz"
                      : !value.toString().isEmail
                          ? "Geçerli bir mail adresi giriniz."
                          : null,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        color: AppColors.primaryColor,
                        minWidth: Get.width / 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        onPressed: () {
                          controller.addCarPageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text("Geri", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        color: AppColors.primaryColor,
                        minWidth: Get.width / 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        onPressed: () {
                          if (controller.addCarFormKey2.currentState!.validate()) {
                            //CarModel'e eklenmeli
                            /*controller.registerModel.driving_license_number = controller.rentSerialNumber.text;
                                controller.registerModel.driving_license_date = controller.rentDLdate;
                                controller.registerModel.driving_license_front_image = controller.image1;
                                controller.registerModel.driving_license_front_image_ext = controller.image1ext;
                                controller.registerModel.driving_license_back_image = controller.image2;
                                controller.registerModel.driving_license_back_image_ext = controller.image2ext;*/
                            controller.addCarPageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: const Text(
                          "İleri",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
class carAddPage4 extends StatelessWidget {
  const carAddPage4({
    super.key,
    required this.controller,
  });

  final AddCarController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: controller.addCarFormKey4,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Teslimat Saatlari ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Obx(
                      () => Align(
                        child: MaterialButton(
                          color: AppColors.primaryColor,
                          minWidth: Get.width / 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          onPressed: () {
                            controller.isGeneral.value = !controller.isGeneral.value;
                          },
                          child: Text(controller.isGeneral.value ? "Kendin Belirle" : "Standart", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Visibility(
                    visible: !controller.isGeneral.value,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Haftaiçi"),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableWeekdayStart,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableWeekdayStartTime = pickedTime;
                                        controller.availableWeekdayStart.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableWeekdayEnd,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableWeekdayEndTime = pickedTime;
                                        controller.availableWeekdayEnd.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Haftasonu"),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableWeekendStart,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableWeekEndStartTime = pickedTime;
                                        controller.availableWeekendStart.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableWeekendEnd,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableWeekEndEndTime = pickedTime;
                                        controller.availableWeekendEnd.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isGeneral.value,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Pazartesi"),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableMondayStart,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableMondayStartTime = pickedTime;
                                        controller.availableMondayStart.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableMondayEnd,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableMondayEndTime = pickedTime;
                                        controller.availableMondayEnd.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Salı"),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableTuesdayStart,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableTuesdayStartTime = pickedTime;
                                        controller.availableTuesdayStart.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableTuesdayEnd,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableTuesdayEndTime = pickedTime;
                                        controller.availableTuesdayEnd.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Çarşamba"),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableWednesdayStart,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableWednesdayStartTime = pickedTime;
                                        controller.availableWednesdayStart.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableWednesdayEnd,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableWednesdayEndTime = pickedTime;
                                        controller.availableWednesdayEnd.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Perşembe"),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableThursdayStart,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableThursdayStartTime = pickedTime;
                                        controller.availableThursdayStart.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableThursdayEnd,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableThursdayEndTime = pickedTime;
                                        controller.availableThursdayEnd.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Cuma"),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableFridayStart,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableFridayStartTime = pickedTime;
                                        controller.availableFridayStart.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableFridayEnd,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableFridayEndTime = pickedTime;
                                        controller.availableFridayEnd.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Cumartesi"),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableSaturdayStart,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableSaturdayStartTime = pickedTime;
                                        controller.availableSaturdayStart.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableSaturdayEnd,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableSaturdayEndTime = pickedTime;
                                        controller.availableSaturdayEnd.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Pazar"),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableSundayStart,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableSundayStartTime = pickedTime;
                                        controller.availableSundayStart.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: controller.availableSundayEnd,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: controller.selectedTime);

                                      if (pickedTime != null) {
                                        controller.availableSundayEndTime = pickedTime;
                                        controller.availableSundayEnd.text = "${pickedTime.hour}: ${pickedTime.minute}";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        color: AppColors.primaryColor,
                        minWidth: Get.width / 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        onPressed: () {
                          controller.addCarPageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text("Geri", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        color: AppColors.primaryColor,
                        minWidth: Get.width / 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        onPressed: () {
                          if (controller.addCarFormKey4.currentState!.validate()) {
                            if (controller.isGeneral.value) {
                              //controllerdaki verileri doldur
                              //Standart verileri doldur
                            } else {
                              //controllerdaki verileri doldur
                              //Genel verileri doldur
                            }

                            controller.addCarPageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: const Text(
                          "İleri",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class carAddPage3 extends StatelessWidget {
  const carAddPage3({
    super.key,
    required this.controller,
  });

  final AddCarController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: controller.addCarFormKey3,
            child: Column(
              children: [
                //Plate Number
                TextFormField(
                  controller: controller.plateNumberController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text("Plaka Numarası"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.car_rental, color: Colors.grey),
                  ),
                  validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                ),
                const SizedBox(height: 8),
                //Km Aralığı
                Obx(
                  () => Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            const Icon(Icons.list, size: 16, color: Colors.black),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(controller.kmDropdownHint.value,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        items: controller.kmList
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        //value: controller.brandDropdownValue.value,
                        onChanged: (String? value) {
                          controller.kmDropdownHint.value = value ?? "";
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: Get.width,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black26), color: Colors.white),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                            icon: Icon(Icons.arrow_forward_ios_outlined), iconSize: 14, iconEnabledColor: Colors.black, iconDisabledColor: Colors.white),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: Get.width * 0.8,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility: MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.only(left: 14, right: 14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                //Konum
                MaterialButton(
                  height: Get.height * 0.053,
                  color: Colors.grey,
                  minWidth: Get.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onPressed: () async {
                    // Konum izni kontrolü
                    LocationPermission permission = await Geolocator.checkPermission();

                    if (permission == LocationPermission.denied) {
                      // Konum izni yoksa, izin iste
                      permission = await Geolocator.requestPermission();

                      if (permission == LocationPermission.denied) {
                        CustomDialog.showMessage(
                          context: context,
                          title: "Aracın Teslim Konumu Gereklidir",
                          message: "Lütfen aracın teslim konumunu seçiniz.",
                        ).then((value) => Get.dialog(SelectLoactionCarOwner()));
                        return;
                      }
                    } else if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
                      // Konum izni varsa, kullanıcının konumunu al
                      Position position = await Geolocator.getCurrentPosition();
                      // Haritayı kullanıcının konumuna taşı
                      if (position != null) {
                        controller.cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14.4746);
                        Get.dialog(SelectLoactionCarOwner());
                      }
                    } else {
                      Get.dialog(SelectLoactionCarOwner());
                    }
                  },
                  child: const Text(
                    "Teslimat Konumu Seçiniz",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),

                Obx(() => Visibility(visible: controller.address.value.isNotEmpty, child: Text(controller.address.value))),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        color: AppColors.primaryColor,
                        minWidth: Get.width / 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        onPressed: () {
                          controller.addCarPageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text("Geri", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        color: AppColors.primaryColor,
                        minWidth: Get.width / 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        onPressed: () {
                          if (controller.addCarFormKey3.currentState!.validate()) {
                            if (controller.kmDropdownHint == "Km Aralığı Seçiniz") {
                              CustomDialog.showMessage(
                                context: context,
                                title: "Km Aralığı Boş",
                                message: "Lütfen km aralığı seçiniz.",
                              );
                            } else {
                              controller.addCarPageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          }
                        },
                        child: const Text(
                          "İleri",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class carAddPage1 extends StatelessWidget {
  const carAddPage1({
    super.key,
    required this.controller,
  });

  final AddCarController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.addCarFormKey,
            child: Column(
              children: [
                //Brand
                Obx(
                  () => Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            const Icon(Icons.list, size: 16, color: Colors.black),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(controller.brandDropdownHint.value,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        items: controller.carBrandsList
                            .map<DropdownMenuItem<String>>((BrandElement item) => DropdownMenuItem<String>(
                                  value: item.name,
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        //value: controller.brandDropdownValue.value,
                        onChanged: (String? value) {
                          controller.brandDropdownHint.value = value ?? "";
                          controller.modelDropdownHint.value = "Model Seçiniz";
                          int selectedBrandId = controller.carBrandsList.firstWhere((element) => element.name == value).id;

                          controller.fetchModels(selectedBrandId);
                        },

                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: Get.width,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black26), color: Colors.white),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                            icon: Icon(Icons.arrow_forward_ios_outlined), iconSize: 14, iconEnabledColor: Colors.black, iconDisabledColor: Colors.white),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: Get.width * 0.8,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility: MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.only(left: 14, right: 14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                //Model
                Obx(
                  () => Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            const Icon(Icons.list, size: 16, color: Colors.black),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(controller.modelDropdownHint.value,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        items: controller.carModelList
                            .map<DropdownMenuItem<String>>((ModelElement item) => DropdownMenuItem<String>(
                                  value: item.name,
                                  child: Text(item.name,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        //value: controller.selectedValue,
                        onChanged: (String? value) {
                          controller.modelDropdownHint.value = value ?? "";
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: Get.width,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black26), color: Colors.white),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                            icon: Icon(Icons.arrow_forward_ios_outlined), iconSize: 14, iconEnabledColor: Colors.black, iconDisabledColor: Colors.white),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility: MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.only(left: 14, right: 14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                //Year
                Obx(
                  () => Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            const Icon(Icons.list, size: 16, color: Colors.black),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(controller.yearDropdownHint.value,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        items: controller.carYearList
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        //value: controller.selectedValue,
                        onChanged: (String? value) {
                          controller.yearDropdownHint.value = value ?? "";
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: Get.width,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black26), color: Colors.white),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                            icon: Icon(Icons.arrow_forward_ios_outlined), iconSize: 14, iconEnabledColor: Colors.black, iconDisabledColor: Colors.white),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility: MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.only(left: 14, right: 14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                //Fuel Type
                Obx(
                  () => Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            const Icon(Icons.list, size: 16, color: Colors.black),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(controller.fuelTypeDropdownHint.value,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        items: controller.carFuelTypeList
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        //value: controller.selectedValue,
                        onChanged: (String? value) {
                          controller.fuelTypeDropdownHint.value = value ?? "";
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: Get.width,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black26), color: Colors.white),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                            icon: Icon(Icons.arrow_forward_ios_outlined), iconSize: 14, iconEnabledColor: Colors.black, iconDisabledColor: Colors.white),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility: MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.only(left: 14, right: 14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                //Transmission Type
                Obx(
                  () => Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            const Icon(Icons.list, size: 16, color: Colors.black),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(controller.transmissionTypeDropdownHint.value,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        items: controller.carTransmissionTypeList
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        //value: controller.selectedValue,
                        onChanged: (String? value) {
                          controller.transmissionTypeDropdownHint.value = value ?? "";
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: Get.width,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black26), color: Colors.white),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                            icon: Icon(Icons.arrow_forward_ios_outlined), iconSize: 14, iconEnabledColor: Colors.black, iconDisabledColor: Colors.white),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility: MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.only(left: 14, right: 14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.dailyRentMoney,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text("Günlük Kira Bedelini Giriniz"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.car_rental, color: Colors.grey),
                  ),
                  validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            if (controller.brandDropdownHint == "Marka Seçiniz" || controller.modelDropdownHint == "Model Seçiniz") {
                              CustomDialog.showMessage(
                                context: context,
                                title: "Marka yada model boş",
                                message: "Lütfen marka ve model seçiniz.",
                              );
                            } else {
                              //controller.getDailyRentMoney(controller.brandDropdownHint.value, controller.modelDropdownHint.value);

                              int? dailyRentMoneyInt = int.tryParse(controller.dailyRentMoney.text);
                              String message = "";

                              if (dailyRentMoneyInt != null) {
                                int monthlyRentIncome = dailyRentMoneyInt * 30;
                                message = "Aylık kira getiriniz: ${controller.dailyRentMoney.text} * 30 = $monthlyRentIncome TL";
                              } else {
                                message = "Hatalı bir sayı girişi yapıldı.";
                              }

                              CustomDialog.showMessage(
                                context: context,
                                title: "Aylık Kira Getirisi",
                                message: message,
                              );
                            }
                          },
                          child: Text(
                            "Aylık Kira Getirisini Hesapla",
                            style: TextStyle(color: Colors.black),
                          ))),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: MaterialButton(
                    color: AppColors.primaryColor,
                    minWidth: Get.width / 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    onPressed: () {
                      if (controller.addCarFormKey.currentState!.validate()) {
                        if (controller.brandDropdownHint == "Marka Seçiniz") {
                          CustomDialog.showMessage(
                              context: context, title: "Marka Seçilmedi", message: "Lütfen marka seçiniz.", onPositiveButtonPressed: () {});
                        } else if (controller.modelDropdownHint == "Model Seçiniz") {
                          CustomDialog.showMessage(
                              context: context, title: "Model Seçilmedi", message: "Lütfen model seçiniz.", onPositiveButtonPressed: () {});
                        } else if (controller.yearDropdownHint == "Yıl Seçiniz") {
                          CustomDialog.showMessage(context: context, title: "Yıl Seçilmedi", message: "Lütfen yıl seçiniz.", onPositiveButtonPressed: () {});
                        } else if (controller.fuelTypeDropdownHint == "Yakıt Tipi Seçiniz") {
                          CustomDialog.showMessage(
                              context: context, title: "Yakıt Tipi Seçilmedi", message: "Lütfen yakıt tipi seçiniz.", onPositiveButtonPressed: () {});
                        } else if (controller.transmissionType == "Vites Tipi Seçiniz") {
                          CustomDialog.showMessage(
                              context: context, title: "Vites Tipi Seçilmedi", message: "Lütfen vites tipi seçiniz.", onPositiveButtonPressed: () {});
                        } else {
                          controller.addCarPageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      }

                      //CarModel'e eklenmeli
                      /*controller.registerModel.driving_license_number = controller.rentSerialNumber.text;
                        controller.registerModel.driving_license_date = controller.rentDLdate;
                        controller.registerModel.driving_license_front_image = controller.image1;
                        controller.registerModel.driving_license_front_image_ext = controller.image1ext;
                        controller.registerModel.driving_license_back_image = controller.image2;
                        controller.registerModel.driving_license_back_image_ext = controller.image2ext;*/
                    },
                    child: const Text(
                      "İleri",
                      style: TextStyle(color: Colors.white),
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

class SelectLoactionCarOwner extends GetView<AddCarController> {
  const SelectLoactionCarOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        height: Get.height * 0.5,
        width: Get.width * .75,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            MapPicker(
              iconWidget: Image.asset("assets/pngs/location_icon.png"),
              mapPickerController: controller.mapPickerController,
              child: GoogleMap(
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: controller.cameraPosition,
                onMapCreated: (GoogleMapController gmcontroller) => controller.googleMapController.complete(gmcontroller),
                onCameraMoveStarted: () {
                  controller.mapPickerController.mapMoving!();
                  controller.gmAddressText.value = "Kontrol Ediliyor...";
                },
                onCameraMove: (cameraPosition) => controller.cameraPosition = cameraPosition,
                onCameraIdle: () async {
                  controller.mapPickerController.mapFinishedMoving!();
                  // get address name from camera position
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    controller.cameraPosition.target.latitude,
                    controller.cameraPosition.target.longitude,
                  );

                  if (placemarks.isNotEmpty) {
                    Placemark address = placemarks.first;
                    controller.gmAddressText.value =
                        "${address.thoroughfare!} ${address.subThoroughfare}, ${address.locality} ${address.subLocality}, ${address.administrativeArea} ${address.postalCode}";
                    controller.rxCity.value = address.administrativeArea!;
                    controller.rxDistrict.value = address.subLocality!;
                  }

                  /*
                  // update the ui with the address
                  textController.text = '${placemarks.first.administrativeArea} - ${placemarks.first.subLocality}';
                  String fullAddress =
                      '${placemarks.first.thoroughfare} ${placemarks.first.subThoroughfare}, ${placemarks.first.locality} ${placemarks.first.subLocality}, ${placemarks.first.administrativeArea} ${placemarks.first.postalCode}';
                  authController.registerModel.address = fullAddress;
                  authController.registerModel.city = placemarks.first.administrativeArea!;
                  authController.registerModel.district = placemarks.first.subLocality!;
                  */
                },
              ),
            ),
            Positioned(
              top: 8,
              child: Container(
                width: Get.width * .65,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                child: Obx(
                  () => Text(controller.gmAddressText.value),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    controller.address.value = controller.gmAddressText.value;
                    controller.city = controller.rxCity.value;
                    controller.district = controller.rxDistrict.value;
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFA3080C)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),
                  child: const Text(
                    "Konumu Seç",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Color(0xFFFFFFFF),
                      fontSize: 19,
                      // height: 19/19,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

*/

