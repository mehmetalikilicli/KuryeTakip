// ignore_for_file: invalid_use_of_protected_member, must_be_immutable, unused_import, avoid_print, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/components/lists.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/helpers/helper_functions.dart';
import 'package:kurye_takip/pages/add_car/test_add_controller.dart';
import 'package:kurye_takip/pages/dashboard/dashboard.dart';
import 'package:kurye_takip/pages/zzz/gnav_bar/gnav_bar.dart';
import 'package:kurye_takip/pages/profile/profile.dart';
import 'package:kurye_takip/pages/widgets/images.dart';
import 'package:kurye_takip/pages/widgets/inputs.dart';
import 'package:map_picker/map_picker.dart';

import '../../app_constants/app_colors.dart';

class TestAddCarView extends StatelessWidget {
  TestAddCarView({super.key});

  final TestAddController controller = Get.put(TestAddController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HelpFunctions.closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(title: const Text("ARAÇ EKLEME")),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          children: const [
            //TestAddPageTwo(),
            TestAddPageOne(),
            TestAddPageThree(),
            TestAddPageFour(),
            TestAddPageFive(),
            TestAddPageSix(),
            TestAddPageSeven(),
          ],
        ),
      ),
    );
  }
}

class TestAddPageOne extends GetView<TestAddController> {
  const TestAddPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.testAddPageOneFormKey,
        child: Column(
          children: [
            const Align(alignment: Alignment.centerLeft, child: Text("Araç Bilgileri - 1", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            const Divider(height: 12),
            DropdownButtonFormField2(
              decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Araç türünü seçiniz", Icons.list, Colors.black),
              isExpanded: true,
              icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
              iconSize: 20,
              buttonPadding: const EdgeInsets.only(),
              dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              dropdownPadding: EdgeInsets.zero,
              items: Lists.carTypeList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
              selectedItemHighlightColor: AppColors.primaryColor,
              onChanged: (value) => controller.changeCarType(value),
              validator: (value) => value == null ? "Lütfen araç türünü seçiniz" : null,
              value: controller.carTypeText,
              dropdownOverButton: true,
              dropdownMaxHeight: Get.height * .25,
              scrollbarAlwaysShow: true,
            ),
            const SizedBox(height: 8),
            Obx(
              () => controller.loadingBrands.isTrue
                  ? DropdownButtonFormField2(
                      decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Marka seçiniz", Icons.list, Colors.black),
                      isExpanded: true,
                      icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                      iconSize: 20,
                      buttonPadding: const EdgeInsets.only(),
                      dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      dropdownPadding: EdgeInsets.zero,
                      items: const [],
                    )
                  : DropdownButtonFormField2(
                      decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Marka seçiniz", Icons.list, Colors.black),
                      isExpanded: true,
                      icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                      iconSize: 20,
                      buttonPadding: const EdgeInsets.only(),
                      dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      dropdownPadding: EdgeInsets.zero,
                      items: controller.carBrandsList.value
                          .map((item) => DropdownMenuItem<String>(value: item.brandId.toString(), child: Text(item.brandName)))
                          .toList(),
                      selectedItemHighlightColor: AppColors.primaryColor,
                      onChanged: (value) => controller.changeBrand(value),
                      validator: (value) => value == null ? "Lütfen araç markası seçiniz" : null,
                      value: controller.carBrand,
                      dropdownOverButton: true,
                      dropdownMaxHeight: Get.height * .25,
                      scrollbarAlwaysShow: true,
                    ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => controller.loadingModels.isTrue
                  ? DropdownButtonFormField2(
                      decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Model seçiniz", Icons.list, Colors.black),
                      isExpanded: true,
                      icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                      iconSize: 20,
                      buttonPadding: const EdgeInsets.only(),
                      dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      dropdownPadding: EdgeInsets.zero,
                      items: const [],
                    )
                  : DropdownButtonFormField2(
                      decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Model seçiniz", Icons.list, Colors.black),
                      isExpanded: true,
                      icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                      iconSize: 20,
                      buttonPadding: const EdgeInsets.only(),
                      dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      dropdownPadding: EdgeInsets.zero,
                      items: controller.carModelList.value.map((item) => DropdownMenuItem<String>(value: item.id.toString(), child: Text(item.name))).toList(),
                      selectedItemHighlightColor: AppColors.primaryColor,
                      onChanged: (value) {
                        controller.carModel = value;
                        final selectedModel = controller.carModelList.value.firstWhere((item) => item.id.toString() == value);
                        controller.recomendation_price = "${selectedModel.min_recomendation_price ?? 0} - ${selectedModel.max_recomendation_price ?? 0}";
                        controller.carTypeIndex = selectedModel.car_type;
                      },
                      validator: (value) => value == null ? "Lütfen araç modeli seçiniz" : null,
                      value: controller.carModel,
                      dropdownOverButton: true,
                      dropdownMaxHeight: Get.height * .25,
                      scrollbarAlwaysShow: true,
                    ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField2(
              decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Model yılı seçiniz", Icons.list, Colors.black),
              isExpanded: true,
              icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
              iconSize: 20,
              buttonPadding: const EdgeInsets.only(),
              dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              dropdownPadding: EdgeInsets.zero,
              items: Lists.generateCarYearList().map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
              selectedItemHighlightColor: AppColors.primaryColor,
              onChanged: (value) => controller.carYear = value,
              validator: (value) => value == null ? "Lütfen araç model yılını seçiniz" : null,
              value: controller.carYear,
              dropdownOverButton: true,
              dropdownMaxHeight: Get.height * .25,
              scrollbarAlwaysShow: true,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField2(
              decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Yakıt türü seçiniz", Icons.list, Colors.black),
              isExpanded: true,
              icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
              iconSize: 20,
              buttonPadding: const EdgeInsets.only(),
              dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              dropdownPadding: EdgeInsets.zero,
              items: Lists.carFuelTypeList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
              selectedItemHighlightColor: AppColors.primaryColor,
              onChanged: (value) => controller.carFuel = value,
              validator: (value) => value == null ? "Lütfen yakıt türünü seçiniz" : null,
              value: controller.carFuel,
              dropdownOverButton: true,
              dropdownMaxHeight: Get.height * .25,
              scrollbarAlwaysShow: true,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField2(
              decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Vites türü seçiniz", Icons.list, Colors.black),
              isExpanded: true,
              icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
              iconSize: 20,
              buttonPadding: const EdgeInsets.only(),
              dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              dropdownPadding: EdgeInsets.zero,
              items: Lists.carTransmissionTypeList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
              selectedItemHighlightColor: AppColors.primaryColor,
              onChanged: (value) => controller.carTransmission = value,
              validator: (value) => value == null ? "Lütfen vites türünü seçiniz" : null,
              value: controller.carTransmission,
              dropdownOverButton: true,
              dropdownMaxHeight: Get.height * .25,
              scrollbarAlwaysShow: true,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => controller.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                  child: const Text("Geri"),
                ),*/
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: () => controller.checkPageOneComplete(),
                    child: const Text("İlerle"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TestAddPageTwo extends GetView<TestAddController> {
  const TestAddPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.testAddPageTwoFormKey,
        child: Column(
          children: [
            const Align(alignment: Alignment.centerLeft, child: Text("Araç Sahibi Bilgileri", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            const Divider(height: 12),
            TextFormField(
              controller: controller.name,
              keyboardType: TextInputType.name,
              decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "İsim", Icons.person, AppColors.primaryColor),
              validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              enabled: true,
              controller: controller.surname,
              keyboardType: TextInputType.name,
              decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Soyisim", Icons.person, AppColors.primaryColor),
              validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.phone,
              keyboardType: TextInputType.phone,
              decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Telefon", Icons.phone, AppColors.primaryColor),
              validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "E-Posta Adresi", Icons.mail, AppColors.primaryColor),
              validator: (value) => value!.isEmpty
                  ? "Boş bırakılamaz"
                  : !value.toString().isEmail
                      ? "Geçerli bir mail adresi giriniz."
                      : null,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () => controller.checkPageTwoComplete(),
                child: const Text("İlerle"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TestAddPageThree extends GetView<TestAddController> {
  const TestAddPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.testAddPageThreeKey,
        child: Column(
          children: [
            const Align(alignment: Alignment.centerLeft, child: Text("Araç Bilgileri - 2", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            const Divider(height: 12),
            TextFormField(
              controller: controller.carPlate,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.characters,
              decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Araç Plakası", CupertinoIcons.car_detailed, AppColors.primaryColor),
              validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField2(
              decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Km Bilgisi", CupertinoIcons.gauge, AppColors.primaryColor),
              isExpanded: true,
              icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
              iconSize: 20,
              buttonPadding: const EdgeInsets.only(),
              dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              dropdownPadding: EdgeInsets.zero,
              items: Lists.kmList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
              selectedItemHighlightColor: AppColors.primaryColor,
              onChanged: (value) => controller.selectedKm = value,
              validator: (value) => value == null ? "Lütfen km bilgisi seçiniz." : null,
              value: controller.selectedKm,
              dropdownOverButton: true,
              dropdownMaxHeight: Get.height * .25,
              scrollbarAlwaysShow: true,
            ),
            const SizedBox(height: 4),
            MaterialButton(
              color: AppColors.softPrimaryColor,
              minWidth: Get.width,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              onPressed: () => Get.bottomSheet(
                const AddCarLocationsBottomSheet(),
                isScrollControlled: true,
              ),
              child: Row(
                children: [
                  const Expanded(child: Text("Teslimat Adresleri")),
                  const SizedBox(width: 8),
                  Obx(() => Text("(${controller.locations.value.length})")),
                ],
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.address.value.isNotEmpty,
                child: RichText(
                  text: TextSpan(
                    text: 'Adres: ',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(text: controller.address.value, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => controller.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                  child: const Text("Geri"),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => controller.checkPageThreeComplete(),
                  child: const Text("İlerle"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TestAddPageFour extends GetView<TestAddController> {
  const TestAddPageFour({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.testAddPageFourKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                TextFormField(
                  readOnly: true,
                  controller: controller.availableCarDate,
                  decoration: const InputDecoration(
                    label: Text("Araç Uygunluk Takvimi"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range_rounded, color: AppColors.primaryColor),
                  ),
                  validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                  onTap: () async {
                    final result = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (result != null) {
                      controller.availableCarDateStart = result.start;
                      controller.availableCarDateEnd = result.end;

                      controller.availableCarDate.text = "${DateFormat('dd.MM.yyyy').format(result.start)} - ${DateFormat('dd.MM.yyyy').format(result.end)}";
                    } else {}
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 2, color: Colors.black),
            Row(
              children: [
                const Expanded(child: Text("Teslimat Saatleri ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                const SizedBox(width: 8),
                Obx(
                  () => Align(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => controller.isGeneralTime.toggle(),
                      child: Text(controller.isGeneralTime.isTrue ? "Standart" : "Kendin Belirle"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(
              () => Column(
                children: controller.isGeneralTime.isTrue
                    ? [
                        const Divider(height: 12),
                        AddCarTimeRow(
                          date: 'Haftaiçi',
                          input1: controller.availableWeekdayStart,
                          input2: controller.availableWeekdayEnd,
                          time1: controller.availableWeekdayStartTime,
                          time2: controller.availableWeekdayEndTime,
                        ),
                        const Divider(height: 12),
                        AddCarTimeRow(
                          date: 'Haftasonu',
                          input1: controller.availableWeekendStart,
                          input2: controller.availableWeekendEnd,
                          time1: controller.availableWeekEndStartTime,
                          time2: controller.availableWeekEndEndTime,
                        ),
                        const Divider(height: 12),
                      ]
                    : [
                        const Divider(height: 12),
                        AddCarTimeRow(
                          date: 'Pazartesi',
                          input1: controller.availableMondayStart,
                          input2: controller.availableMondayEnd,
                          time1: controller.availableMondayStartTime,
                          time2: controller.availableMondayEndTime,
                        ),
                        const Divider(height: 12),
                        AddCarTimeRow(
                          date: 'Salı',
                          input1: controller.availableTuesdayStart,
                          input2: controller.availableTuesdayEnd,
                          time1: controller.availableTuesdayStartTime,
                          time2: controller.availableTuesdayEndTime,
                        ),
                        const Divider(height: 12),
                        AddCarTimeRow(
                          date: 'Çarşamba',
                          input1: controller.availableWednesdayStart,
                          input2: controller.availableWednesdayEnd,
                          time1: controller.availableWednesdayStartTime,
                          time2: controller.availableWednesdayEndTime,
                        ),
                        const Divider(height: 12),
                        AddCarTimeRow(
                          date: 'Perşembe',
                          input1: controller.availableThursdayStart,
                          input2: controller.availableThursdayEnd,
                          time1: controller.availableThursdayStartTime,
                          time2: controller.availableThursdayEndTime,
                        ),
                        const Divider(height: 12),
                        AddCarTimeRow(
                          date: 'Cuma',
                          input1: controller.availableFridayStart,
                          input2: controller.availableFridayEnd,
                          time1: controller.availableFridayStartTime,
                          time2: controller.availableFridayEndTime,
                        ),
                        const Divider(height: 12),
                        AddCarTimeRow(
                          date: 'Cumartesi',
                          input1: controller.availableSaturdayStart,
                          input2: controller.availableSaturdayEnd,
                          time1: controller.availableSaturdayStartTime,
                          time2: controller.availableSaturdayEndTime,
                        ),
                        const Divider(height: 12),
                        AddCarTimeRow(
                          date: 'Pazar',
                          input1: controller.availableSundayStart,
                          input2: controller.availableSundayEnd,
                          time1: controller.availableSundayStartTime,
                          time2: controller.availableSundayEndTime,
                        ),
                        const Divider(height: 12),
                      ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => controller.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                  child: const Text("Geri"),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => controller.checkPageFourComplete(),
                  child: const Text("İlerle"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TestAddPageFive extends GetView<TestAddController> {
  const TestAddPageFive({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(alignment: Alignment.centerLeft, child: Text("Araç Fotoğrafları", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
          const Divider(height: 12),
          Obx(
            () => ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              primary: false,
              itemCount: controller.carImages.value.length,
              separatorBuilder: (context, index) => const Divider(height: 12),
              itemBuilder: (context, index) {
                return Obx(
                  () => Row(
                    children: controller.carImages.value[index].load.isFalse
                        ? [
                            Expanded(child: Text(controller.carImages.value[index].description)),
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
                                  controller.pickImageAtIndex(ImageSource.camera, index);
                                } else if (result == "Gallery") {
                                  controller.pickImageAtIndex(ImageSource.gallery, index);
                                } else {}
                              },
                              child: const Text("Fotoğraf Yükle"),
                            ),
                          ]
                        : [
                            Image.memory(
                              base64Decode(controller.carImages.value[index].photo64),
                              width: Get.width * 0.25,
                              fit: BoxFit.fitWidth,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(controller.carImages.value[index].header, style: const TextStyle(fontWeight: FontWeight.w600))),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => controller.removeImageAtIndex(index),
                              child: const Icon(CupertinoIcons.xmark_circle, color: CupertinoColors.systemRed),
                            ),
                          ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () => controller.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                child: const Text("Geri"),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () => controller.checkPageFiveComplete(),
                child: const Text("İlerle"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TestAddPageSix extends GetView<TestAddController> {
  const TestAddPageSix({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: controller.testAddPageSixFormKey,
        child: Column(
          children: [
            const Align(alignment: Alignment.centerLeft, child: Text("İndirim Oranları", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            const Divider(height: 12),
            Column(
              children: [
                const Align(alignment: Alignment.centerLeft, child: Text("Haftalık İndirim Oranı")),
                DropdownButtonFormField2(
                  decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Haftalık kira indirim oranını seçiniz.", Icons.list, Colors.black),
                  isExpanded: true,
                  icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                  iconSize: 20,
                  buttonPadding: const EdgeInsets.only(),
                  dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  dropdownPadding: EdgeInsets.zero,
                  items: controller.weeklyDiscountRateList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
                  selectedItemHighlightColor: AppColors.primaryColor,
                  onChanged: (value) => controller.weeklyDiscount = value,
                  value: controller.weeklyDiscount,
                  dropdownOverButton: true,
                  dropdownMaxHeight: Get.height * .25,
                  scrollbarAlwaysShow: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                const Align(alignment: Alignment.centerLeft, child: Text("Aylık İndirim Oranı")),
                DropdownButtonFormField2(
                  decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Aylık kira indirim oranını seçiniz.", Icons.list, Colors.black),
                  isExpanded: true,
                  icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                  iconSize: 20,
                  buttonPadding: const EdgeInsets.only(),
                  dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  dropdownPadding: EdgeInsets.zero,
                  items: controller.monthlyDiscountRateList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
                  selectedItemHighlightColor: AppColors.primaryColor,
                  onChanged: (value) => controller.monthlyDiscount = value,
                  value: controller.monthlyDiscount,
                  dropdownOverButton: true,
                  dropdownMaxHeight: Get.height * .25,
                  scrollbarAlwaysShow: true,
                ),
              ],
            ),
            SizedBox(height: 8),
            Column(
              children: [
                const Align(alignment: Alignment.centerLeft, child: Text("Minimum kira günü")),
                TextFormField(
                  controller: controller.minRentDay,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Minimum kira günü", CupertinoIcons.car_detailed, AppColors.primaryColor),
                  validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                const Align(alignment: Alignment.centerLeft, child: Text("Günlük kira bedeli")),
                TextFormField(
                  controller: controller.dailyRentPrice,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Günlük kira bedeli", Icons.car_rental, AppColors.primaryColor).copyWith(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                CustomDialog.showMessage(
                                    context: context,
                                    title: "Bilgilendirme",
                                    message:
                                        "Aracınızın talep görebilmesi için uygun bir kira bedeli belirlemenizi öneririz. Piyasa fiyatından yüksek kalan fiyatlar kullanıcılar tarafından aracınızın talep edilmemesine neden olabilir.");
                              },
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.green,
                              ),
                            ),
                          ),
                  validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () => controller.monthlyRentPriceCalculator(),
                child: const Text("Aylık kira getirisini hesapla"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  "Aracınızı uzun dönem kiralamak ister misiniz?",
                  style: TextStyle(fontSize: 12),
                )),
                Obx(() => Switch(
                      value: controller.isLongTerm.value,
                      onChanged: (value) {
                        controller.isLongTerm.toggle();
                      },
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => controller.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                  child: const Text("Geri"),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => controller.checkPageSixComplete(),
                  child: const Text("İlerle"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TestAddPageSeven extends GetView<TestAddController> {
  const TestAddPageSeven({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.testAddPageSevenKey,
        child: Column(
          children: [
            const Align(
                alignment: Alignment.centerLeft, child: Text("Kullanıcıya Notunuz(Opsiyonel)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            const Divider(height: 12),
            TextField(
                controller: controller.note,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                decoration: InputWidgets().noteDecoration(Colors.grey, Colors.red, "Kullanıcıya iletmek istediğiniz notu giriniz.")),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => controller.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                  child: const Text("Geri"),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () async {
                    if (await controller.saveCar()) {
                      // ignore: use_build_context_synchronously
                      CustomDialog.showMessage(
                          context: context,
                          title: "Araç Kayıt Başarılı",
                          message: "Araç kaydınız başarılı, admin onayından sonra \"Araçlarım\" kısmından bakabilirsiniz.",
                          onPositiveButtonPressed: () {
                            Get.offAll(Dashboard());
                          });
                    } else {
                      // ignore: use_build_context_synchronously
                      CustomDialog.showMessage(
                        context: context,
                        title: "Araç Kaydı Başarısız",
                        message: "Araç kaydınız başarısız.",
                        onPositiveButtonPressed: () {
                          Get.off(ProfilePage());
                        },
                      );
                    }
                  },
                  child: const Text("Kaydet"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FutureErrorWidget extends StatelessWidget {
  const FutureErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Icon(Icons.error, color: CupertinoColors.systemRed));
  }
}

class FutureLoadingWidget extends StatelessWidget {
  const FutureLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CupertinoActivityIndicator(color: Colors.black));
  }
}

class AppCustomDialog extends StatelessWidget {
  AppCustomDialog({
    super.key,
    this.title,
    this.message,
    this.positiveButtonText,
    this.negativeButtonText,
    this.onNegativeButtonPressed,
    this.onPositiveButtonPressed,
  });

  String? title;
  String? message;
  String? positiveButtonText;
  Function? onPositiveButtonPressed;
  String? negativeButtonText;
  Function? onNegativeButtonPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null
          ? Text(
              title!,
              textAlign: TextAlign.center,
            )
          : null,
      content: message != null ? Text(message!) : null,
      actions: <Widget>[
        TextButton(
          onPressed: () => onNegativeButtonPressed != null ? onNegativeButtonPressed!() : Get.back(),
          child: Text(negativeButtonText ?? 'Kapat'),
        ),
        TextButton(
          onPressed: () => onPositiveButtonPressed != null ? onPositiveButtonPressed!() : Get.back(),
          child: Text(positiveButtonText ?? 'Tamam'),
        ),
      ],
    );
  }
}

class TestAddSelectLocationCarOwner extends GetView<TestAddController> {
  const TestAddSelectLocationCarOwner({super.key});

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
                },
              ),
            ),
            Positioned(
              top: 8,
              child: Container(
                width: Get.width * .65,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                padding: const EdgeInsets.all(8),
                child: Obx(() => Text(controller.gmAddressText.value)),
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
                    AddCarLocation carLocation = AddCarLocation(
                      latitude: controller.cameraPosition.target.latitude.toString(),
                      longitude: controller.cameraPosition.target.longitude.toString(),
                      address: controller.gmAddressText.value,
                      city: controller.rxCity.value,
                      district: controller.rxDistrict.value,
                    );

                    if (carLocation.city != "İzmir") {
                      CustomDialog.showMessage(
                        context: context,
                        title: "Konum Yanlış",
                        message: "Şu an sadece İzmir konumuna izin verilmektedir.",
                      );
                    } else {
                      controller.locations.add(carLocation);
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
                    "Adresi Ekle",
                    style: TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Color(0xFFFFFFFF), fontSize: 19),
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

class AddCarTimeInput extends GetView<TestAddController> {
  AddCarTimeInput({super.key, required this.textController, required this.time});

  TextEditingController textController;
  TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: textController,
      decoration: InputWidgets().timeDecoration(Colors.grey, Colors.red, "00:00"),
      textAlign: TextAlign.center,
      validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: time);
        if (pickedTime != null) {
          time = pickedTime;
          textController.text = "${pickedTime.hour}: ${pickedTime.minute}";
        }
      },
    );
  }
}

class AddCarTimeRow extends StatelessWidget {
  AddCarTimeRow({
    super.key,
    required this.date,
    required this.input1,
    required this.input2,
    required this.time1,
    required this.time2,
  });

  String date;
  TextEditingController input1, input2;
  TimeOfDay time1, time2;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(date),
        )),
        const SizedBox(width: 8),
        Row(
          children: [
            SizedBox(width: Get.width * .25, child: AddCarTimeInput(textController: input1, time: time1)),
            const SizedBox(width: 8),
            SizedBox(width: Get.width * .25, child: AddCarTimeInput(textController: input2, time: time2)),
          ],
        ),
      ],
    );
  }
}

class SelectImageFromBottomSheet extends StatelessWidget {
  const SelectImageFromBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Fotoğraf Yükle", style: TextStyle(color: Colors.black, fontSize: 18)),
              const SizedBox(height: 12),
              ListTile(
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                minLeadingWidth: Get.width * .1,
                leading: const Icon(CupertinoIcons.photo_camera),
                title: const Text("Fotoğraf Çek"),
                onTap: () => Get.back(result: "Camera"),
              ),
              ListTile(
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                minLeadingWidth: Get.width * .1,
                leading: const Icon(CupertinoIcons.photo),
                title: const Text("Fotoğraflarımdan Seç"),
                onTap: () => Get.back(result: "Gallery"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCarLocationsBottomSheet extends GetView<TestAddController> {
  const AddCarLocationsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(12.0, 12, 12, 0),
                child: Text("Teslimat Adresleri", style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
              const Divider(height: 12),
              Obx(
                () => controller.locations.value.isEmpty
                    ? const Text("Lütfen en az bir teslimat adresi ekleyiniz.")
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.locations.value.length,
                        separatorBuilder: (context, index) => const Divider(height: 12),
                        itemBuilder: (context, index) => ListTile(
                          title: Text(controller.locations.value[index].address, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          subtitle: Text("${controller.locations.value[index].district}/${controller.locations.value[index].city}"),
                          trailing: GestureDetector(
                            onTap: () => controller.locations.removeAt(index),
                            child: const Icon(CupertinoIcons.xmark_circle, color: CupertinoColors.systemRed),
                          ),
                        ),
                      ),
              ),
              const Divider(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: const BorderSide(width: 0.5, color: CupertinoColors.activeGreen),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => Get.back(),
                      child: const Text("Kapat"),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: CupertinoColors.activeGreen,
                        foregroundColor: CupertinoColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: const BorderSide(width: 0.5, color: CupertinoColors.activeGreen),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () {
                        controller.openSelectLocationDialog();
                      },
                      child: const Text("Yeni Teslimat Adresi Ekle"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
