// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, use_build_context_synchronously, duplicate_ignore, avoid_print, unrelated_type_equality_checks, invalid_use_of_protected_member

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/components/lists.dart';
import 'package:kurye_takip/helpers/helper_functions.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/auth/authentication.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/widgets/inputs.dart';
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
              Tab(text: "Aracını Kiraya Ver"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GestureDetector(
              onTap: () => HelpFunctions.closeKeyboard(),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.rentPageController,
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: controller.rentForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: controller.rentName,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
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
                              textCapitalization: TextCapitalization.words,
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: controller.rentMail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                label: Text("Eposta"),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              onPressed: () async {
                                LocationPermission permission = await Geolocator.checkPermission();

                                if (permission == LocationPermission.denied) {
                                  // Konum izni yoksa, izin iste
                                  permission = await Geolocator.requestPermission();

                                  if (permission == LocationPermission.denied) {
                                    CustomDialog.showMessage(
                                      context: context,
                                      title: "Aracın Teslim Konumu Gereklidir",
                                      message: "Lütfen aracın teslim konumunu seçiniz.",
                                    ).then((value) => Get.dialog(const SelectLoactionRegisterRent()));
                                    return;
                                  }
                                } else if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
                                  // Konum izni varsa, kullanıcının konumunu al
                                  Position position = await Geolocator.getCurrentPosition();
                                  // Haritayı kullanıcının konumuna taşı
                                  if (position != null) {
                                    controller.cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14.4746);
                                    Get.dialog(const SelectLoactionRegisterRent());
                                  }
                                } else {
                                  Get.dialog(const SelectLoactionRegisterRent());
                                }
                              },
                              child:
                                  Obx(() => Text(controller.address.value.isNotEmpty ? "Konum Değiştir" : "Konum Seç", style: TextStyle(color: Colors.black))),
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () => Visibility(
                                visible: controller.address.value.isNotEmpty,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text("Seçilen Konum: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(controller.address.value),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
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
                                      Get.offAll(const LoginPage());
                                    },
                                    child: const Text(
                                      "Girişe Dön",
                                      style: TextStyle(color: Colors.white),
                                    ),
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
                                      if (controller.rentForm.currentState!.validate()) {
                                        if (controller.address.value.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Lütfen adres seçiniz')),
                                          );
                                        } else {
                                          controller.registerModel.name = controller.rentName.text;
                                          controller.registerModel.surname = controller.rentSurname.text;
                                          controller.registerModel.phone = controller.rentPhone.text;
                                          controller.registerModel.email = controller.rentMail.text;
                                          controller.registerModel.password = Helpers.encryption(controller.rentPassword.text);
                                          controller.registerModel.address = controller.address.value;
                                          controller.registerModel.city = controller.city;
                                          controller.registerModel.district = controller.district;

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
                              ],
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
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              label: const Text("Ehliyet Numarası"),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.credit_card, color: AppColors.primaryColor),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            "assets/pngs/ehliyet.png",
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            "Ehliyetinizin ön yüzündeki 5 numaralı bilgi ehliyet kimlik numaranızdır.",
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text("Tamam"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.info_outlined, size: 32),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                            ],
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
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                controller.rentDLdate = pickedDate;
                                controller.rentDLdateInput.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                              } else {}
                            },
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: controller.drivingLicencesImages.value.length,
                              separatorBuilder: (BuildContext context, int index) => const Divider(
                                height: 12,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Obx(
                                  () => Row(
                                    children: controller.drivingLicencesImages.value[index].load.isFalse
                                        ? [
                                            Expanded(child: Text(controller.drivingLicencesImages.value[index].description)),
                                            const SizedBox(width: 8),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: CupertinoColors.activeGreen,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                side: const BorderSide(width: 0.5, color: CupertinoColors.activeGreen),
                                                visualDensity: VisualDensity.compact,
                                              ),
                                              onPressed: () async {
                                                String result = await Get.bottomSheet(const SelectImageFromBottomSheet()) ?? "";
                                                if (result == "Camera") {
                                                  controller.pickImageAtFrontOrBack(ImageSource.camera, index);
                                                } else if (result == "Gallery") {
                                                  controller.pickImageAtFrontOrBack(ImageSource.gallery, index);
                                                } else {}
                                              },
                                              child: const Text("Fotoğraf Yükle"),
                                            ),
                                          ]
                                        : [
                                            Image.memory(
                                              base64Decode(controller.drivingLicencesImages.value[index].photo64),
                                              width: Get.width * 0.25,
                                              fit: BoxFit.fitWidth,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                                child: Text(controller.drivingLicencesImages.value[index].header,
                                                    style: const TextStyle(fontWeight: FontWeight.w600))),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                controller.removeImageAtIndex(index);
                                              },
                                              child: const Icon(CupertinoIcons.xmark_circle, color: CupertinoColors.systemRed),
                                            ),
                                          ],
                                  ),
                                );
                              },
                            ),
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
                                    controller.rentPageController.previousPage(
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
                                    if (controller.rentForm2.currentState!.validate()) {
                                      if (controller.drivingLicencesImages[0].photo64.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Ehliyetinizin ön yüzünü yükleyiniz.')),
                                        );
                                      } else if (controller.drivingLicencesImages[1].photo64.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Ehliyetinizin arka yüzünü yükleyiniz.")),
                                        );
                                      } else {
                                        controller.registerModel.driving_license_number = controller.rentDLnumber.text;
                                        controller.registerModel.driving_license_date = controller.rentDLdate;
                                        controller.registerModel.driving_license_front = controller.drivingLicencesImages[0].photo64;
                                        controller.registerModel.driving_license_front_ext = controller.drivingLicencesImages[0].ext;
                                        controller.registerModel.driving_license_back = controller.drivingLicencesImages[1].photo64;
                                        controller.registerModel.driving_license_back_ext = controller.drivingLicencesImages[1].ext;

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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: controller.rentForm3,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.rentName,
                            enabled: false,
                            textCapitalization: TextCapitalization.words,
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
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              label: Text("Soyisim"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                            ),
                            validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.rentTC,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(11), // Maksimum 11 karakter sınırı
                            ],
                            decoration: InputDecoration(
                                label: const Text("TC Kimlik Numarası"),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(
                                  Icons.credit_card,
                                  color: AppColors.primaryColor,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Center(child: Text("Bilgilendirme!")),
                                        contentPadding: const EdgeInsets.all(20),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Yasa gereği araç kiralayanların bilgileri KABİS(Kiralık Araç Bildirim Sistemi)'e bildirilmektedir.",
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 20),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.back(); // Pencereyi kapat
                                              },
                                              child: const Text("Tamam"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(
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
                              DateTime now = DateTime.now();
                              DateTime startDate = DateTime(now.year - 88, now.month, now.day);
                              DateTime minDate = DateTime(now.year - 18, now.month, now.day);

                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                firstDate: startDate,
                                lastDate: minDate,
                              );

                              if (pickedDate != null) {
                                controller.rentBirthDate = pickedDate;
                                controller.rentBirthDateInput.text = DateFormat("dd-MM-yyyy").format(pickedDate);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.rentSerialNumber,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              label: Text("TC Kimlik Kartı Seri No", style: TextStyle(fontSize: 12)),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.numbers,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                            ],
                            validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField2(
                            decoration: const InputDecoration(
                              label: Text("Cinsiyetiniz"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.list, color: AppColors.primaryColor),
                            ),
                            //decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Cinsiyetinizi seçiniz", Icons.list, Colors.black),
                            isExpanded: true,
                            icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.primaryColor),
                            iconSize: 20,
                            buttonPadding: const EdgeInsets.only(),
                            dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                            dropdownPadding: EdgeInsets.zero,
                            items: Lists.genderList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
                            selectedItemHighlightColor: AppColors.primaryColor,
                            onChanged: (value) => controller.rentGender.value = value!,
                            dropdownOverButton: true,
                            dropdownMaxHeight: Get.height * .25,
                            scrollbarAlwaysShow: true,
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
                            onPressed: () async {
                              if (controller.rentForm3.currentState!.validate()) {
                                if (controller.rentGender.value == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen cinsiyetinizi seçiniz')));
                                } else {
                                  controller.registerModel.tc = controller.rentTC.text;
                                  controller.registerModel.birth_date = controller.rentBirthDate;
                                  controller.registerModel.serial_number = controller.rentSerialNumber.text;
                                  controller.registerModel.gender = controller.rentGender.value;
                                  try {
                                    RegisterResponse registerResponse = await controller.Register(controller.registerModel);

                                    if (registerResponse.success == true) {
                                      // ignore: use_build_context_synchronously
                                      CustomDialog.showMessage(
                                          context: context,
                                          title: "Kayıt Başarılı",
                                          message: "Kaydınız başarılı, admin onayından sonra giriş yapabilirsiniz.",
                                          onPositiveButtonPressed: () {
                                            Get.offAll(const LoginPage());
                                          });
                                    } else {
                                      CustomDialog.showMessage(
                                        context: context,
                                        title: "Kayıt Başarısız",
                                        message: registerResponse.message,
                                      );
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              }
                            },
                          ),
                          Align(
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => HelpFunctions.closeKeyboard(),
              child: SafeArea(
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
                          controller: controller.ownerPhone,
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.ownerMail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            label: Text("Eposta"),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? "Boş bırakılamaz"
                              : !value.toString().isEmail
                                  ? "Geçerli bir mail adresi giriniz."
                                  : null,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => TextFormField(
                              obscureText: controller.ownerPasswordHide.isTrue,
                              controller: controller.ownerPassword,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                label: const Text("Şifre"),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.password, color: AppColors.primaryColor),
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
                                label: const Text("Şifre tekrar"),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.password, color: AppColors.primaryColor),
                                suffixIcon: GestureDetector(
                                    onTap: () => controller.ownerPassword2Hide.toggle(),
                                    child: Icon(controller.ownerPassword2Hide.isTrue ? Icons.visibility : Icons.visibility_off)),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? "Boş bırakılamaz"
                                  : value.trim() != controller.ownerPassword.text.trim()
                                      ? "Şifreler uyuşmuyor"
                                      : null),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Ticari bir amacınız var mı?(Rent a car)"),
                            Obx(() => Switch(
                                  value: controller.isCommercial.value,
                                  onChanged: (value) {
                                    controller.isCommercial.value = value;
                                  },
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                color: AppColors.primaryColor,
                                minWidth: Get.width / 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                onPressed: () {
                                  Get.offAll(const LoginPage());
                                },
                                child: const Text(
                                  "Girişe Dön",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              MaterialButton(
                                color: AppColors.primaryColor,
                                minWidth: Get.width / 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                onPressed: () async {
                                  if (controller.ownerForm.currentState!.validate()) {
                                    controller.registerModel2.name = controller.ownerName.text;
                                    controller.registerModel2.surname = controller.ownerSurname.text;
                                    controller.registerModel2.phone = controller.ownerPhone.text;
                                    controller.registerModel2.email = controller.ownerMail.text;
                                    controller.registerModel2.password = Helpers.encryption(controller.ownerPassword.text);
                                    controller.registerModel2.is_vehicle_owner = 1;
                                    controller.registerModel2.is_commercial = controller.isCommercial == true ? 1 : 0;
                                    try {
                                      RegisterResponse registerResponse = await controller.Register(controller.registerModel2);

                                      if (registerResponse.success == true) {
                                        // ignore: use_build_context_synchronously
                                        CustomDialog.showMessage(
                                            context: context,
                                            title: "Kayıt Başarılı",
                                            //message: "Kaydınız başarılı, admin onayından sonra giriş yapabilirsiniz.",
                                            onPositiveButtonPressed: () {
                                              Get.offAll(const LoginPage());
                                            });
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        CustomDialog.showMessage(
                                            context: context,
                                            title: "Kayıt Başarısız",
                                            message: registerResponse.message,
                                            onPositiveButtonPressed: () {
                                              //Get.offAll(LoginPage());
                                            });
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                },
                                child: const Text(
                                  "Kaydol",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
        height: Get.height * 0.9,
        width: Get.width * .9,
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
                onMapCreated: (GoogleMapController gmcontroller) {
                  if (!controller.googleMapController.isCompleted) {
                    controller.googleMapController.complete(gmcontroller);
                  }
                },
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
                    if (controller.rxCity.value != "İzmir") {
                      CustomDialog.showMessage(
                        context: context,
                        title: "Konum Yanlış",
                        message: "Şu an sadece İzmir konumuna izin verilmektedir.",
                      );
                    } else {
                      controller.address.value = controller.gmAddressText.value;
                      controller.city = controller.rxCity.value;
                      controller.district = controller.rxDistrict.value;
                      Get.back();
                    }
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
