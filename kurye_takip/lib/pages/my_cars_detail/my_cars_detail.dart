// ignore_for_file: must_be_immutable, prefer_const_constructors, invalid_use_of_protected_member

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/components/lists.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/my_cars/my_cars.dart';
import 'package:kurye_takip/pages/my_cars_detail/my_cars_detail_controller.dart';
import 'package:kurye_takip/pages/widgets/inputs.dart';
import 'package:map_picker/map_picker.dart';

class MyCarsDetailPage extends StatefulWidget {
  MyCarsDetailPage({super.key, required this.carElement});
  CarElement carElement;

  @override
  State<MyCarsDetailPage> createState() => _MyCarsDetailPageState();
}

class _MyCarsDetailPageState extends State<MyCarsDetailPage> {
  MyCarsDetailController controller = Get.put(MyCarsDetailController());

  @override
  Widget build(BuildContext context) {
    controller.carElement = widget.carElement;
    controller.FillInfo();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carElement.plate!),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          /*ListTile(
            leading: Icon(CupertinoIcons.doc_person),
            title: Text("Araç Sahibi Bilgileri"),
            trailing: Icon(Icons.edit),
            onTap: () {
              Get.dialog(UserInfoEditDialog());
            },
          ),*/
          ListTile(
            leading: Icon(CupertinoIcons.info_circle),
            title: Text("Araç Bilgileri"),
            trailing: Icon(Icons.edit),
            onTap: () {
              Get.to(CarInfoEditPage());
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.location_circle),
            title: Text("Teslimat Adresleri"),
            trailing: Icon(Icons.edit),
            onTap: () {
              Get.to(CarLocationEditPage());
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.timer),
            title: Text("Tarih ve Saat"),
            trailing: Icon(Icons.edit),
            onTap: () {
              Get.to(CarDateAndTimeEditPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library_outlined),
            title: Text("Fotoğraflar"),
            trailing: Icon(Icons.edit),
            onTap: () {
              Get.to(CarPhotosEditPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.percent_outlined),
            title: Text("Fiyat ve İndirimler"),
            trailing: Icon(Icons.edit),
            onTap: () {
              Get.to(PricesAndDiscounts());
            },
          ),
          ListTile(
            leading: Icon(Icons.note_outlined),
            title: Text("Kullanıcıya Not"),
            trailing: Icon(Icons.edit),
            onTap: () {
              Get.to(NoteEditPage());
            },
          ),
          Obx(
            () => Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: controller.isActive.value == 0 ? Colors.green.shade800 : Colors.red.shade800,
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(
                      color: controller.isActive.value == 0 ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    controller.changeActivity();
                  },
                  child: controller.isActive.value == 0 ? Text("Aracı Yayına Al") : Text("Aracı Yayından Kaldır"),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 16, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade800,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(
                    color: Colors.red.shade800,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  CustomDialog.showMessage(
                    context: context,
                    title: "Uyarı",
                    message: "Aracı silmek istediğinize emin misiniz?",
                    negativeButtonText: "İptal",
                    positiveButtonText: "Sil",
                  );
                },
                child: Text("Aracı Sil"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoEditDialog extends GetView<MyCarsDetailController> {
  const UserInfoEditDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller.nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'İsim'),
                  validator: (value) => value!.isEmpty ? 'Boş bırakılamaz' : null,
                ),
                TextFormField(
                  controller: controller.surnameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Soyisim'),
                  validator: (value) => value!.isEmpty ? 'Boş bırakılamaz' : null,
                ),
                TextFormField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Telefon'),
                  validator: (value) => value!.isEmpty ? 'Boş bırakılamaz' : null,
                ),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'E-Posta Adresi'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Boş bırakılamaz';
                    } else if (!value.isEmail) {
                      return 'Geçerli bir mail adresi giriniz.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('İptal'),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        if (controller.formKey.currentState!.validate()) {
                          GeneralResponse generalResponse = await controller.editUserInfo();
                          if (generalResponse.success == true) {
                            // ignore: use_build_context_synchronously
                            CustomDialog.showMessage(
                              context: context,
                              title: "Başarılı",
                              message: "Araç sahibi bilgileri güncelleme başarılı.",
                              onPositiveButtonPressed: () {
                                Get.off(MyCarsPage());
                              },
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            CustomDialog.showMessage(
                              context: context,
                              title: "Başarısız",
                              message: "Araç sahibi bilgileri güncellenemedi.",
                              onPositiveButtonPressed: () {
                                Get.off(MyCarsPage());
                              },
                            );
                          }
                        }
                      },
                      child: Text('Kaydet'),
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

class CarDateAndTimeEditPage extends GetView<MyCarsDetailController> {
  const CarDateAndTimeEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.dateAndTimeEditKey,
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
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    controller.editCarDeliveryTimes(controller.carElement.carId!);
                    controller.editCarAvailableDate(controller.carElement.carId!);
                  },
                  child: const Text("Kaydet"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CarInfoEditPage extends GetView<MyCarsDetailController> {
  const CarInfoEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: controller.getCarEditInformations(),
        builder: (context, snapshot) {
          /*if (snapshot.hasError) {
            return const FutureErrorWidget();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const FutureLoadingWidget();
          } else {*/
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.carInfoEditKey,
              child: Column(
                children: [
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
                            items: controller.carModelList.value
                                .map((item) => DropdownMenuItem<String>(value: item.id.toString(), child: Text(item.name)))
                                .toList(),
                            selectedItemHighlightColor: AppColors.primaryColor,
                            onChanged: (value) {
                              controller.carModel = value;
                              //final selectedModel = controller.carModelList.value.firstWhere((item) => item.id.toString() == value);
                              //controller.recomendation_price = selectedModel.recomendation_price;
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
                    value: controller.carElement.year.toString(),
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
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: () => controller.checkCarInfoAndSave(),
                      child: const Text("Kaydet"),
                    ),
                  ),
                ],
              ),
            ),
          );
          //}
        },
      ),
    );
  }
}

class CarLocationEditPage extends GetView<MyCarsDetailController> {
  const CarLocationEditPage({super.key});

  void initState() {
    controller.getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
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
                          onTap: () {
                            if (controller.locations.length > 1) {
                              controller.deleteLocation(controller.locations[index].id);
                              controller.locations.removeAt(index);
                            } else {
                              CustomDialog.showMessage(
                                context: context,
                                title: "Hata",
                                message: "En az bir teslimat noktası olmak zorunda",
                              );
                            }
                          },
                          child: const Icon(CupertinoIcons.xmark_circle, color: CupertinoColors.systemRed),
                        ),
                      ),
                    ),
            ),
            const Divider(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}

class CarLocationEditSelectLocation extends GetView<MyCarsDetailController> {
  const CarLocationEditSelectLocation({super.key});
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
                    CarAvailableLocation carAvailableLocation = CarAvailableLocation(
                      id: 0,
                      carId: controller.carElement.carId!,
                      latitude: controller.cameraPosition.target.latitude.toDouble(),
                      longitude: controller.cameraPosition.target.longitude.toDouble(),
                      address: controller.gmAddressText.value,
                      city: controller.rxCity.value,
                      district: controller.rxDistrict.value,
                    );
                    controller.saveLocation(carAvailableLocation);
                    controller.locations.add(carAvailableLocation);
                    Get.back();
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

class CarPhotosEditPage extends GetView<MyCarsDetailController> {
  const CarPhotosEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
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
                              controller.carImages[index].isChanged
                                  ? Image.memory(
                                      base64Decode(controller.carImages.value[index].photo64),
                                      width: Get.width * 0.25,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : Image.network(
                                      controller.carImages[index].path,
                                      width: Get.width * 0.25,
                                      fit: BoxFit.fitWidth,
                                    ),

                              /*Image.network(
                                controller.carImages[index].path,
                                width: Get.width * 0.25,
                                fit: BoxFit.fitWidth,
                              ),
                              Image.memory(
                                base64Decode(controller.carImages.value[index].photo64),
                                width: Get.width * 0.25,
                                fit: BoxFit.fitWidth,
                              ),*/
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
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () => controller.checkPhotosandSave(),
                child: const Text("Kaydet"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PricesAndDiscounts extends GetView<MyCarsDetailController> {
  const PricesAndDiscounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${controller.carElement.plate}"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Form(
            key: controller.pricesAndDiscountsKey,
            child: Column(
              children: [
                const Align(alignment: Alignment.centerLeft, child: Text("İndirim Oranları", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                const Divider(height: 12),
                Column(
                  children: [
                    const Align(alignment: Alignment.centerLeft, child: Text("Haftalık İndirim Oranı")),
                    DropdownButtonFormField2(
                      decoration:
                          InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Haftalık kira indirim oranını seçiniz.", Icons.list, Colors.black),
                      isExpanded: true,
                      icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                      iconSize: 20,
                      buttonPadding: const EdgeInsets.only(),
                      dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      dropdownPadding: EdgeInsets.zero,
                      items: controller.weeklyDiscountRateList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
                      selectedItemHighlightColor: AppColors.primaryColor,
                      onChanged: (value) => controller.weeklyDiscount = value,
                      value: "%${controller.carElement.weeklyRent.toString()}",
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
                      value: "%${controller.carElement.monthlyRent.toString()}",
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
                          InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Minimum Kira günü", CupertinoIcons.car_detailed, AppColors.primaryColor),
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
                      decoration: InputWidgets().dropdownDecoration(
                          Colors.grey, Colors.red, "Tavsiye edilen fiyat: ${controller.recomendation_price} TL", Icons.car_rental, AppColors.primaryColor),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: () {
                      controller.editPriceandDiscount();
                    },
                    child: const Text("Kaydet"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class NoteEditPage extends GetView<MyCarsDetailController> {
  const NoteEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.notEditKey,
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
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () async {
                    controller.editNote();
                  },
                  child: const Text("Kaydet"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
