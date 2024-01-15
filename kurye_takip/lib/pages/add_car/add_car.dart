import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
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
          carAddPage1(controller: controller),
          carAddPage2(),
          SafeArea(
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
                          prefixIcon: Icon(Icons.car_rental, color: AppColors.primaryColor),
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
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              items: controller.kmList
                                  .map((String item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                            overflow: TextOverflow.ellipsis),
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
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black26), color: Colors.white),
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
                        onPressed: () {
                          Get.dialog(SelectLoactionCarOwner());
                        },
                        child: const Text(
                          "Teslimat Konumunu Seçiniz",
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
                                controller.addCarPageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
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
                  decoration: const InputDecoration(
                    label: Text("İsim"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                  ),
                  validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                ),
                const SizedBox(height: 8),
                //Surname
                TextFormField(
                  enabled: true,
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
                //Phone
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
                //Email
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
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        //value: controller.brandDropdownValue.value,
                        onChanged: (String? value) {
                          controller.brandDropdownHint.value = value ?? "";
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
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
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
                              controller.getDailyRentMoney(controller.brandDropdownHint.value, controller.modelDropdownHint.value);
                              CustomDialog.showMessage(
                                context: context,
                                title: "Aylık Kira Getirisi",
                                message: "Aylık kira getiriniz: ${controller.dailyRentMoney} * 30 = ${controller.dailyRentMoney * 30} TL",
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
                      if (controller.brandDropdownHint == "Marka Seçiniz") {
                        CustomDialog.showMessage(context: context, title: "Marka Seçilmedi", message: "Lütfen marka seçiniz.", onPositiveButtonPressed: () {});
                      } else if (controller.modelDropdownHint == "Model Seçiniz") {
                        CustomDialog.showMessage(context: context, title: "Model Seçilmedi", message: "Lütfen model seçiniz.", onPositiveButtonPressed: () {});
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
