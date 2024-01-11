// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/controllers/authentication.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:map_picker/map_picker.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("RENTEKER"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Araç Kirala"),
              Tab(text: "Aracını Kirala"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            PageView(
              controller: controller.rentPageController,
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: controller.rentForm,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.rentName,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              label: Text("İsim"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                            ),
                            validator: (value) => value!.isEmpty ? "boş bırakılamaz" : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.rentSurname,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              label: Text("Soyisim"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                            ),
                            validator: (value) => value!.isEmpty ? "boş bırakılamaz" : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.rentPhone,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              label: Text("Telefon"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                            ),
                            validator: (value) => value!.isEmpty ? "boş bırakılamaz" : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.rentMail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              label: Text("Mail"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                            ),
                            validator: (value) => value!.isEmpty
                                ? "boş bırakılamaz"
                                : !value.toString().isEmail
                                    ? "Geçerli bir mail adresi giriniz."
                                    : null,
                          ),
                          /*const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.rentPhone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: const Text("TC Kimlik Numarası"),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person, color: AppColors.primaryColor),
                            suffixIcon: GestureDetector(
                              onTap: () {},
                              child: Icon(Icons.warning_amber_rounded),
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? "boş bırakılamaz" : null,
                        ),*/
                          const SizedBox(height: 8),
                          Obx(
                            () => TextFormField(
                              obscureText: controller.rentPasswordHide.isTrue,
                              controller: controller.rentPassword,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                label: const Text("Şifre"),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.password, color: AppColors.primaryColor),
                                suffixIcon: GestureDetector(
                                  onTap: () => controller.rentPasswordHide.toggle(),
                                  child: Icon(controller.rentPasswordHide.isTrue ? Icons.visibility : Icons.visibility_off),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? "boş bırakılamaz"
                                  : value.trim() != controller.rentPassword2.text.trim()
                                      ? "Şifreler uyuşmuyor"
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => TextFormField(
                              obscureText: controller.rentPassword2Hide.isTrue,
                              controller: controller.rentPassword2,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                label: const Text("Şifre Tekrar"),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.password, color: AppColors.primaryColor),
                                suffixIcon: GestureDetector(
                                  onTap: () => controller.rentPassword2Hide.toggle(),
                                  child: Icon(controller.rentPassword2Hide.isTrue ? Icons.visibility : Icons.visibility_off),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? "boş bırakılamaz"
                                  : value.trim() != controller.rentPassword.text.trim()
                                      ? "Şifreler uyuşmuyor"
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.rentDLnumber,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              label: Text("Ehliyet Numarası"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.credit_card, color: AppColors.primaryColor),
                            ),
                            validator: (value) => value!.isEmpty ? "boş bırakılamaz" : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            readOnly: true,
                            controller: controller.rentDLdateInput,
                            decoration: const InputDecoration(
                              label: Text("Ehliyet Tarihi"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                            ),
                            validator: (value) => value!.isEmpty ? "boş bırakılamaz" : null,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: controller.rentDLdate,
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                controller.rentDLdate = pickedDate;
                                controller.rentDLdateInput.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                              } else {}
                            },
                          ),
                          const SizedBox(height: 8),
                          MaterialButton(
                            color: AppColors.softPrimaryColor,
                            minWidth: Get.width,
                            child: const Text("Ehliyet Ön Yüzünü Yükle"),
                            onPressed: () async {
                              final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                              if (!image.isNull) {
                                final bytes = await image!.readAsBytes();
                                var result = await FlutterImageCompress.compressWithList(bytes, minWidth: 720, minHeight: 480, quality: 50, rotate: 0);
                                final byteLength = result.lengthInBytes;
                                final kByte = byteLength / 1024;
                                final mByte = kByte / 1024;
                                if (mByte > 2.5) {
                                  log("Maksimum boyut 2.5 mb olabilir.");
                                } else {
                                  controller.image1 = base64.encode(result);
                                  controller.image1ext = image.path.split(".").last;
                                }
                              } else {}
                            },
                          ),
                          const SizedBox(height: 4),
                          MaterialButton(
                            color: AppColors.softPrimaryColor,
                            minWidth: Get.width,
                            child: const Text("Ehliyet Arka Yüzünü Yükle"),
                            onPressed: () async {
                              final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                              if (!image.isNull) {
                                final bytes = await image!.readAsBytes();
                                var result = await FlutterImageCompress.compressWithList(bytes, minWidth: 720, minHeight: 480, quality: 50, rotate: 0);
                                final byteLength = result.lengthInBytes;
                                final kByte = byteLength / 1024;
                                final mByte = kByte / 1024;
                                if (mByte > 2.5) {
                                  log("Maksimum boyut 2.5 mb olabilir.");
                                } else {
                                  controller.image2 = base64.encode(result);
                                  controller.image2ext = image.path.split(".").last;
                                }
                              } else {}
                            },
                          ),
                          const SizedBox(height: 8),
                          MaterialButton(
                            color: AppColors.softPrimaryColor,
                            minWidth: Get.width,
                            child: const Text("Konum Seç"),
                            onPressed: () {
                              Get.dialog(const SelectLoactionRegisterRent());
                            },
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Visibility(
                              visible: controller.address.value.isNotEmpty,
                              child: Text(controller.address.value),
                            ),
                          ),
                          const SizedBox(height: 8),
                          MaterialButton(
                            color: AppColors.primaryColor,
                            minWidth: Get.width,
                            child: const Text("KAYIT OL"),
                            onPressed: () {
                              if (controller.rentForm.currentState!.validate()) {
                                if (controller.image1.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Eyliyetinizin ön yüzünü yükleyiniz.')),
                                  );
                                } else if (controller.image2.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Eyliyetinizin arka yüzünü yükleyiniz.')),
                                  );
                                } else if (controller.address.value.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Lütfen adres seçiniz')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Processing Data')),
                                  );
                                }
                              } else {
                                String body = json.encode({
                                  "name": controller.rentName.text,
                                  "surname": controller.rentSurname.text,
                                  "phone": controller.rentPhone.text,
                                  "email": controller.rentMail.text,
                                  "password": Helpers.encryptPassword(controller.rentPassword.text),
                                  "driving_license_number": controller.rentDLnumber.text,
                                  "driving_license_date": controller.rentDLdate,
                                  "driving_license_front": controller.image1,
                                  "driving_license_front_ext": controller.image1ext,
                                  "driving_license_back": controller.image2,
                                  "driving_license_back_ext": controller.image2ext,
                                  "address": controller.address,
                                  "city": controller.city,
                                  "district": controller.district,
                                });

                                //controller.Register(body);
                                /*ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Eksik veri girişi')),
                              );*/
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          MaterialButton(
                            onPressed: () {},
                            child: const Text("İleri"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text("Second Page"),
                )
              ],
            ),
            PageView(
              controller: controller.rentPageController,
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: controller.rentForm,
                      child: Column(
                        children: [
                          TextFormField(
                              // Diğer TextFormField'lar burada...
                              ),
                          const SizedBox(height: 8),
                          MaterialButton(
                            onPressed: () {
                              // İleri butonuna tıklandığında bir sonraki sayfaya geçiş
                              controller.rentPageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text("İleri"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Sayfa 2 içeriği
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: controller.ownerForm,
                    child: Column(
                      children: [
                        // Diğer widget'lar burada...
                        MaterialButton(
                          onPressed: () {
                            // İleri butonuna tıklandığında bir sonraki sayfaya geçiş
                            controller.rentPageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text("İleri"),
                        ),
                        const SizedBox(height: 8),
                        MaterialButton(
                          onPressed: () {
                            // Geri butonuna tıklandığında bir önceki sayfaya geçiş
                            controller.rentPageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text("Geri"),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sayfa 3 içeriği - Sadece Geri butonu
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Sayfa 3 içeriği burada
                      MaterialButton(
                        onPressed: () {
                          // Geri butonuna tıklandığında bir önceki sayfaya geçiş
                          controller.rentPageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text("Geri"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectLoactionRegisterRent extends GetView<RegisterController> {
  const SelectLoactionRegisterRent({super.key});

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
