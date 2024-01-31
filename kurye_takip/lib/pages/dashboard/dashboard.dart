// ignore_for_file: unnecessary_null_comparison, sized_box_for_whitespace, deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardDrawer(),
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          ClipRRect(
            child: IconButton(
              icon: const Icon(Icons.person_2_outlined),
              onPressed: () {
                Get.to(const ProfilePage());
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
                    ],
                  ),
                  Obx(
                    () => ListView.separated(
                      padding: const EdgeInsets.only(top: 8),
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
                    ),
                  )
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Filtreler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(height: 2, color: Colors.black),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        const Align(alignment: Alignment.centerLeft, child: Text("Tarih Aralığı")),
                        Stack(
                          children: [
                            TextFormField(
                              readOnly: true,
                              controller: controller.filterDateText,
                              decoration: InputWidgets().dateDecoration(Colors.grey, Colors.red, "Takvim Aralığı Seçiniz"),
                              onTap: () async {
                                final result = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (result != null) {
                                  controller.filterDateStart = result.start;
                                  controller.filterDateEnd = result.end;

                                  controller.filterDateText.text =
                                      "${DateFormat('dd.MM.yyyy').format(result.start)} - ${DateFormat('dd.MM.yyyy').format(result.end)}";
                                } else {}
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  onPressed: () {
                                    controller.clearDate();
                                  },
                                  icon: const Icon(Icons.close)),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        const Align(alignment: Alignment.centerLeft, child: Text("Yakıt türü")),
                        DropdownButtonFormField2(
                          decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Yakıt türü seçiniz", Icons.list, Colors.black),
                          isExpanded: true,
                          icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                          iconSize: 20,
                          buttonPadding: const EdgeInsets.only(),
                          dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                          dropdownPadding: EdgeInsets.zero,
                          items: controller.carFuelTypeList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
                          selectedItemHighlightColor: AppColors.primaryColor,
                          onChanged: (value) => controller.carFuel = value,
                          value: controller.carFuel,
                          dropdownOverButton: true,
                          dropdownMaxHeight: Get.height * .25,
                          scrollbarAlwaysShow: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        const Align(alignment: Alignment.centerLeft, child: Text("Vites Türü")),
                        DropdownButtonFormField2(
                          decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Vites türü", Icons.list, Colors.black),
                          isExpanded: true,
                          icon: const Icon(CupertinoIcons.chevron_down, color: AppColors.dartGreyColor),
                          iconSize: 20,
                          buttonPadding: const EdgeInsets.only(),
                          dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                          dropdownPadding: EdgeInsets.zero,
                          items: controller.carTransmissionTypeList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
                          selectedItemHighlightColor: AppColors.primaryColor,
                          onChanged: (value) => controller.carTransmission = value,
                          value: controller.carTransmission,
                          dropdownOverButton: true,
                          dropdownMaxHeight: Get.height * .25,
                          scrollbarAlwaysShow: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        const Align(alignment: Alignment.centerLeft, child: Text("Minimum kira günü")),
                        TextFormField(
                          controller: controller.minRentDay,
                          keyboardType: TextInputType.number,
                          decoration: InputWidgets().dropdownDecoration(Colors.grey, Colors.red, "Minimum Kira günü", CupertinoIcons.calendar, Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Fiyat"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: Get.width * .25,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: controller.minPrice,
                                  onTap: () async {},
                                  decoration: InputWidgets().timeDecoration(Colors.grey, Colors.red, "00:00"),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: Get.width * .25,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: controller.maxPrice,
                                  decoration: InputWidgets().timeDecoration(Colors.grey, Colors.red, "00:00"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Uzun Dönem"),
                        Obx(() => Switch(
                              value: controller.filterIsLongTerm.value,
                              onChanged: (value) {
                                controller.filterIsLongTerm.value = value;
                                if (!value && controller.filterIsShortTerm.value == false) {
                                  controller.filterIsShortTerm.value = true;
                                }
                              },
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Kısa Dönem"),
                        Obx(() => Switch(
                              value: controller.filterIsShortTerm.value,
                              onChanged: (value) {
                                controller.filterIsShortTerm.value = value;
                                if (!value && controller.filterIsLongTerm.value == false) {
                                  controller.filterIsLongTerm.value = true;
                                }
                              },
                            )),
                      ],
                    ),
                    ButtonBar(
                      buttonPadding: const EdgeInsets.only(left: 4),
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue.shade800,
                            visualDensity: VisualDensity.compact,
                            side: BorderSide(color: Colors.blue.shade800),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            controller.clearFilters();
                          },
                          child: const Text("Filtreleri Temizle"),
                        ),
                        const SizedBox(width: 2),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            visualDensity: VisualDensity.compact,
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            controller.applyFilters();
                            Get.back();
                          },
                          child: const Text("Uygula", style: TextStyle(color: Colors.green)),
                        )
                      ],
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

class DashboardSlider extends StatelessWidget {
  const DashboardSlider({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: dashboardController.bannerSvgAssets.length,
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlay: true,
        aspectRatio: 16 / 8,
        enlargeCenterPage: true,
      ),
      itemBuilder: (context, index, realIdx) {
        if (index < dashboardController.bannerSvgAssets.length) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SvgPicture.asset(
                dashboardController.bannerSvgAssets[index],
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
                : "assets/logo/_dart.png",
            fit: BoxFit.cover,
            height: Get.width * 9 / 16,
            width: Get.width,
            errorBuilder: (context, error, stackTrace) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: SvgPicture.asset("assets/logo/_dart.png"),
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
      () => Container(
        width: buttonWidth,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            //shape: const RoundedRectangleBorder(),
            side: BorderSide(
              color: controller.selectedTypes.contains(id) ? AppColors.primaryColor : Colors.grey,
            ),
            foregroundColor: controller.selectedTypes.contains(id) ? AppColors.primaryColor : Colors.grey,
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
