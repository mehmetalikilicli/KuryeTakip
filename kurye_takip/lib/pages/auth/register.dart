// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
              physics: const NeverScrollableScrollPhysics(),
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
                            validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
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
                            validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
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
                            validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
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
                                ? "Boş bırakılamaz"
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
                          validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
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
                                  ? "Boş bırakılamaz"
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
                                  ? "Boş bırakılamaz"
                                  : value.trim() != controller.rentPassword.text.trim()
                                      ? "Şifreler uyuşmuyor"
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          MaterialButton(
                            height: Get.height * 0.053,
                            color: AppColors.softPrimaryColor,
                            minWidth: Get.width,
                            child: Text(
                              "Konum Seç",
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: MaterialButton(
                                color: AppColors.primaryColor,
                                minWidth: Get.width / 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                onPressed: () {
                                  if (controller.rentForm.currentState!.validate()) {
                                    if (controller.address.value.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Lütfen adres seçiniz')),
                                      );
                                    } else {
                                      controller.rentPageController.nextPage(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: controller.rentForm2,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.rentDLnumber,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              label: Text("Ehliyet Numarası"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.credit_card, color: AppColors.primaryColor),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      contentPadding: EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            "assets/pngs/ehliyet.png",
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            "Ehliyetinizin ön yüzündeki 5 numaralı bilgi ehliyet kimlik numaranızdır.",
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text("Tamam"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.info_outlined,
                                  size: 32,
                                ),
                              )),
                          validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
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
                          validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: const Text("Ehliyet Ön Yüzünü Yükle", style: TextStyle(color: Colors.white)),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          child: const Text("Ehliyet Arka Yüzünü Yükle", style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  color: AppColors.primaryColor,
                                  minWidth: Get.width / 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  onPressed: () {
                                    controller.rentPageController.previousPage(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: const Text("Geri", style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  color: AppColors.primaryColor,
                                  minWidth: Get.width / 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  onPressed: () {
                                    if (controller.rentForm2.currentState!.validate()) {
                                      if (controller.image1.isEmpty) {
                                        //Will be deleted
                                        controller.rentPageController.nextPage(
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Ehliyetinizin ön yüzünü yükleyiniz.')),
                                        );
                                      } else if (controller.image2.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Ehliyetinizin arka yüzünü yükleyiniz.")),
                                        );
                                      } else {
                                        controller.rentPageController.nextPage(
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Sayfa 3 içeriği - Sadece Geri butonu
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: controller.rentForm3,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.rentName,
                          enabled: false,
                          decoration: const InputDecoration(
                            label: Text("İsim"),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.rentSurname,
                          enabled: false,
                          decoration: const InputDecoration(
                            label: Text("Soyisim"),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.rentTC,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              label: Text("TC Kimlik Numarası"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.credit_card,
                                color: AppColors.primaryColor,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Center(child: Text("Bilgilendirme!")),
                                      contentPadding: const EdgeInsets.all(20),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Yasa gereği araç kiralayanların bilgileri KABİS(Kiralık Araç Bildirim Sistemi)'e bildirilmektedir.",
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back(); // Pencereyi kapat
                                            },
                                            child: Text("Tamam"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.warning_amber_outlined,
                                  color: Colors.red,
                                  size: 32,
                                ),
                              )),
                          validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          readOnly: true,
                          controller: controller.rentBirthDateInput,
                          decoration: const InputDecoration(
                            label: Text("Doğum Tarihi"),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                          ),
                          validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1930),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              controller.rentBirthDate = pickedDate;
                              controller.rentBirthDateInput.text = DateFormat("dd-MM-yyy").format(pickedDate);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.rentSerialNumber,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            label: Text("Seri No"),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.numbers,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              value: controller.rentGender.value,
                              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.softPrimaryColor),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: AppColors.softPrimaryColor,
                              ),
                              onChanged: (String? newValue) {
                                controller.rentGender.value = newValue ?? "";
                              },
                              items: <String>['', 'Erkek', 'Kadın'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Icon(
                                        value == 'Erkek' ? Icons.male : Icons.female,
                                        color: AppColors.softPrimaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Text(value),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        MaterialButton(
                          color: AppColors.primaryColor,
                          minWidth: Get.width,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Text(
                            "KAYIT OL",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (controller.rentForm3.currentState!.validate()) {
                              if (controller.rentGender.value.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Lütfen cinsiyetinizi seçiniz')),
                                );
                              }
                            } else {}
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: MaterialButton(
                              color: AppColors.primaryColor,
                              minWidth: Get.width / 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              onPressed: () {
                                controller.rentPageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Text(
                                "Geri",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.ownerForm,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.ownerName,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          label: Text("İsim"),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                        ),
                        validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.ownerSurname,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          label: Text("Soyisim"),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.ownerMail,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          label: Text("Telefon"),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.ownerMail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: Text("Eposta"),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => TextFormField(
                            obscureText: controller.ownerPasswordHide.isTrue,
                            controller: controller.ownerPassword,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              label: Text("Şifre"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.password, color: AppColors.primaryColor),
                              suffixIcon: GestureDetector(
                                onTap: () => controller.ownerPasswordHide.toggle(),
                                child: Icon(controller.ownerPasswordHide.isTrue ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                            validator: (value) => value!.isEmpty
                                ? "Boş bırakılamaz"
                                : value.trim() != controller.ownerPassword2.text.trim()
                                    ? "Şifreler uyuşmuyor"
                                    : null),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => TextFormField(
                            obscureText: controller.ownerPassword2Hide.isTrue,
                            controller: controller.ownerPassword2,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              label: Text("Şifre tekrar"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.password, color: AppColors.primaryColor),
                              suffixIcon: Icon(controller.ownerPassword2Hide.isTrue ? Icons.visibility : Icons.visibility_off),
                            ),
                            validator: (value) => value!.isEmpty
                                ? "Boş bırakılamaz"
                                : value.trim() != controller.ownerPassword.text.trim()
                                    ? "Şifreler uyuşmuyor"
                                    : null),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: const Text("Kaydol"),
                      ),
                    ],
                  ),
                ),
              ),
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
