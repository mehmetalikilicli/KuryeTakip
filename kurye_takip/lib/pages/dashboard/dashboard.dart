// ignore_for_file: invalid_use_of_protected_member, unused_local_variable, unnecessary_null_comparison, deprecated_member_use, unused_import

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/components/lists.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/pages/cars_detail/car_detail.dart';
import 'package:kurye_takip/pages/dashboard/dashboard_controller.dart';
import 'package:kurye_takip/pages/profile/profile.dart';
import 'package:kurye_takip/pages/widgets/inputs.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardController controller = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    controller.fetchData();
    //log("controller.fetchData()");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.FillTheMarkers(controller.filteredCars);
          Get.dialog(const SeeCarLocations());
        },
        child: const Icon(CupertinoIcons.location_solid),
      ),
      drawer: const DashboardDrawer(),
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        /*
        leading: IconButton(
          icon: Icon(Icons.filter_alt_outlined),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),*/
        actions: [
          ClipRRect(
            child: IconButton(
              icon: const Icon(Icons.person_2_outlined),
              onPressed: () {
                Get.to(const ProfilePage())!.then((value) => controller.fetchData());
              },
            ),
          ),
        ],
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Renteker", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder(
        future: controller.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Hata!"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator(color: Colors.black));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //CustomCarouselSlider(carController: carController),
                      DashboardSlider(dashboardController: controller),
                      const VehicleTypes(),

                      const SizedBox(height: 4),
                      TextFormField(
                        readOnly: true,
                        controller: controller.filterDateText,
                        decoration: InputWidgets()
                            .dateDecoration(Colors.grey, Colors.red, "Takvim Aralığı Seçiniz")
                            .copyWith(suffixIcon: IconButton(onPressed: () => controller.clearDate(), icon: const Icon(Icons.close))),
                        onTap: () async {
                          final result = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (result != null) {
                            controller.dateChanged(result);
                          } else {}
                        },
                      ),
                      const SizedBox(height: 4),
                      OutlinedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(Get.width, 40)),
                          foregroundColor: MaterialStateProperty.all(Colors.blue.shade800),
                          visualDensity: VisualDensity.comfortable,
                          side: MaterialStateProperty.all(BorderSide(color: Colors.blue.shade800)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: const AutoSizeText("Filtreler", minFontSize: 10, maxFontSize: 16, maxLines: 1),
                      ),
                    ],
                  ),
                  Obx(
                    () => controller.filteredCars.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.only(top: 4),
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.filteredCars.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => CarDetailView(carElement: controller.filteredCars[index], isfloatingActionButtonActive: true, isAppBarActive: true),
                                  );
                                },
                                child: CarElementCard(carItem: controller.filteredCars[index], index: index),
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                          )
                        : const Column(
                            children: [
                              SizedBox(height: 100),
                              Center(
                                child: Text("Seçtiğiniz filtrelere uygun araç bulunmamaktadır."),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class DashboardDrawer extends GetView<DashboardController> {
  const DashboardDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            children: [
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Filtreler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(height: 0, color: Colors.black),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*const Padding(
                        padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                        child: Text("Tarih Aralığı", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      Obx(
                        () => TextFormField(
                          readOnly: true,
                          controller: controller.filterDateText,
                          decoration: InputWidgets().dateDecoration(Colors.grey, Colors.red, "Takvim Aralığı Seçiniz").copyWith(
                                suffixIcon: controller.isDateCloseIconShow.value
                                    ? IconButton(onPressed: () => controller.clearDate(), icon: const Icon(Icons.close))
                                    : Container(),
                              ),
                          onTap: () async {
                            final result = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (result != null) {
                              controller.dateChanged(result);
                            } else {}
                          },
                        ),
                      ),*/
                      const Padding(
                        padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                        child: Text("Marka", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      Obx(
                        () => DropdownButtonFormField2(
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
                      const Padding(
                        padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                        child: Text("Model", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
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
                                  final selectedModel = controller.carModelList.value.firstWhere((item) => item.id.toString() == value);
                                  //controller.carTypeIndex = selectedModel.car_type;
                                },
                                validator: (value) => value == null ? "Lütfen araç modeli seçiniz" : null,
                                value: controller.carModel,
                                dropdownOverButton: true,
                                dropdownMaxHeight: Get.height * .25,
                                scrollbarAlwaysShow: true,
                              ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                        child: Text("Yakıt Türü", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      DropdownButtonFormField2(
                        decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Yakıt türü seçiniz", Icons.list, Colors.black),
                        isExpanded: true,
                        icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                        iconSize: 20,
                        buttonPadding: const EdgeInsets.only(),
                        dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                        dropdownPadding: EdgeInsets.zero,
                        items: Lists.drawerCarFuelTypeList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
                        selectedItemHighlightColor: AppColors.primaryColor,
                        onChanged: (value) => controller.carFuel = value,
                        value: controller.carFuel,
                        dropdownOverButton: true,
                        dropdownMaxHeight: Get.height * .25,
                        scrollbarAlwaysShow: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                        child: Text("Vites  Türü", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      DropdownButtonFormField2(
                        decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Vites türü", Icons.list, Colors.black),
                        isExpanded: true,
                        icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                        iconSize: 20,
                        buttonPadding: const EdgeInsets.only(),
                        dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                        dropdownPadding: EdgeInsets.zero,
                        items: Lists.drawerCarTransmissionTypeList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
                        selectedItemHighlightColor: AppColors.primaryColor,
                        onChanged: (value) => controller.carTransmission = value,
                        value: controller.carTransmission,
                        dropdownOverButton: true,
                        dropdownMaxHeight: Get.height * .25,
                        scrollbarAlwaysShow: true,
                      ),
                      /*const Padding(
                        padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                        child: Text("Min. Kiralama Süresi (Gün)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      TextFormField(
                        controller: controller.minRentDay,
                        keyboardType: TextInputType.number,
                        decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Minimum Kira günü", CupertinoIcons.calendar, Colors.black),
                      ),*/
                      const Padding(
                        padding: EdgeInsets.fromLTRB(4, 8, 0, 2),
                        child: Text("Fiyat Aralığı", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: controller.minPrice,
                              onTap: () async {},
                              decoration: InputWidgets().noteDecoration(Colors.grey, Colors.red, "En Az").copyWith(filled: false),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: controller.maxPrice,
                              decoration: InputWidgets().noteDecoration(Colors.grey, Colors.red, "En Çok").copyWith(filled: false),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(4, 12, 0, 2),
                        child: Text("Ek Özellikler", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Uzun Dönem Kiralama", style: TextStyle(fontSize: 13)),
                          Transform.scale(
                            scale: 0.9,
                            child: Obx(
                              () => Switch(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: controller.filterIsLongTerm.value,
                                onChanged: (value) {
                                  controller.filterIsLongTerm.value = value;
                                  if (!value && controller.filterIsShortTerm.value == false) {
                                    controller.filterIsShortTerm.value = true;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Kısa Dönem Kiralama", style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 8),
                          Transform.scale(
                            scale: 0.9,
                            child: Obx(
                              () => Switch(
                                value: controller.filterIsShortTerm.value,
                                onChanged: (value) {
                                  controller.filterIsShortTerm.value = value;
                                  if (!value && controller.filterIsLongTerm.value == false) {
                                    controller.filterIsLongTerm.value = true;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.only(bottom: 4, top: 4),
                            foregroundColor: Colors.blue.shade800,
                            visualDensity: VisualDensity.comfortable,
                            side: BorderSide(color: Colors.blue.shade800),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            controller.clearFilters();
                          },
                          child: const AutoSizeText("Filtreleri Temizle", minFontSize: 10, maxFontSize: 16, maxLines: 1),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            visualDensity: VisualDensity.comfortable,
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            controller.applyFilters2();
                            Get.back();
                          },
                          child: const Text("Uygula", style: TextStyle(color: Colors.green)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardSlider extends StatelessWidget {
  const DashboardSlider({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: dashboardController.bannerSvgAssets2.length,
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlay: true,
        aspectRatio: 16 / 8,
        enlargeCenterPage: true,
      ),
      itemBuilder: (context, index, realIdx) {
        if (index < dashboardController.bannerSvgAssets2.length) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                dashboardController.bannerSvgAssets2[index],
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 8,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class VehicleTypes extends StatelessWidget {
  const VehicleTypes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CarCategoryButton(
              id: 1,
              title: "Otomobil",
              iconName: "car",
            ),
            SizedBox(width: 8),
            CarCategoryButton(
              id: 2,
              title: "Motorsiklet",
              iconName: "motorcycle",
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CarCategoryButton(
              id: 3,
              title: "Ticari Araç",
              iconName: "truck",
            ),
            SizedBox(width: 8),
            CarCategoryButton(
              id: 4,
              title: "Karavan",
              iconName: "caravan",
            ),
          ],
        ),
      ],
    );
  }
}

class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({
    super.key,
    required this.carController,
  });

  final DashboardController carController;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: carController.bannerUrls.length,
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlay: true,
        aspectRatio: 16 / 7,
        enlargeCenterPage: true,
      ),
      itemBuilder: (context, index, realIdx) {
        if (index < carController.bannerUrls.length) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                carController.bannerUrls[index],
                fit: BoxFit.cover,
                width: Get.width - 8,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class CarElementCard extends GetView<DashboardController> {
  const CarElementCard({super.key, required this.index, required this.carItem});

  final int index;
  final CarElement carItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      shadowColor: AppColors.primaryColor,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            carItem.carAddPhotos != null && carItem.carAddPhotos!.isNotEmpty && carItem.carAddPhotos!.first.photoPath != null
                ? carItem.carAddPhotos!.first.photoPath
                : "assets/logo/logo_dark.png",
            fit: BoxFit.cover,
            height: Get.width * 9 / 16,
            width: Get.width,
            errorBuilder: (context, error, stackTrace) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: SvgPicture.asset("assets/logo/logo_dark.png"),
              );
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${carItem.brandName} ${carItem.modelName}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset("assets/pngs/speed.png", height: 20, width: 20, fit: BoxFit.contain),
                          const Text("Km", style: TextStyle(fontWeight: FontWeight.w800)),
                          Text(
                            "${carItem.km}",
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(color: Colors.black, width: 2, thickness: 1),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset("assets/pngs/model.png", height: 20, width: 20, fit: BoxFit.contain),
                          const Text("Model", style: TextStyle(fontWeight: FontWeight.w800)),
                          Text(
                            carItem.modelName ?? "",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(color: Colors.black, width: 2, thickness: 1),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/pngs/transmission.png", height: 20, width: 20, fit: BoxFit.contain),
                          const Text("Vites", style: TextStyle(fontWeight: FontWeight.w800)),
                          Text(
                            carItem.transmissionType ?? "",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(color: Colors.black, width: 2, thickness: 1),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset("assets/pngs/fuel.png", height: 20, width: 20, fit: BoxFit.contain),
                          const Text("Yakıt", style: TextStyle(fontWeight: FontWeight.w800)),
                          Text(
                            carItem.fuelType ?? "",
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomButton extends StatelessWidget {
  final String destination;
  final String label;

  const MyCustomButton({super.key, required this.destination, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: ElevatedButton(
        onPressed: () {
          //Get.toNamed(destination);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          padding: const EdgeInsets.all(32.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String imagePath;
  final String text1;
  final String text2;
  final String text3;
  final String text4;

  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0), // Padding ayarı
      title: Row(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16.0), // İhtiyaca göre boşluk ekleyebilirsiniz
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text1),
              Text(text2),
              Text(text3),
              Text(text4),
            ],
          ),
        ],
      ),
    );
  }
}

class CarCategoryButton extends GetView<DashboardController> {
  const CarCategoryButton({
    super.key,
    required this.id,
    required this.title,
    required this.iconName,
  });

  final int id;
  final String title;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    double buttonWidth = Get.width / 2 - 24;

    return Obx(
      () => SizedBox(
        width: buttonWidth,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            //shape: const RoundedRectangleBorder(),
            side: BorderSide(
              color: controller.selectedType.value == id ? AppColors.primaryColor : Colors.grey,
            ),
            foregroundColor: controller.selectedType.value == id ? AppColors.primaryColor : Colors.grey,
          ),
          onPressed: () => controller.toggleCarType(id),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/pngs/$iconName.png", height: 20, width: 20, fit: BoxFit.contain),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

class SeeCarLocations extends GetView<DashboardController> {
  const SeeCarLocations({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        height: Get.height * 0.9,
        width: Get.width * 0.9,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            GoogleMap(
              markers: controller.carsMarkers,
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
              onTap: (LatLng latLng) {},
              onCameraMove: (cameraPosition) => controller.cameraPosition = cameraPosition,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 8, 0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    CupertinoIcons.xmark_square_fill,
                    size: 32,
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
