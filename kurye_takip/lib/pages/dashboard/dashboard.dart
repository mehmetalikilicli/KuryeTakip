import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/controllers/dashboard_controller.dart';
import 'package:kurye_takip/model/car_item.dart';
import 'package:kurye_takip/pages/cars_list/car_detail.dart';

import '../widgets/car_category_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Renteker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: dashboardController.fetchData(),
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
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: AppColors.primaryColor),
                        Text("Kadıköy/İstanbul", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //CustomCarouselSlider(carController: carController),
                      DashboardSlider(dashboardController: dashboardController),
                      VehicleTypes(),
                    ],
                  ),
                  Obx(
                    () => ListView.separated(
                      padding: const EdgeInsets.only(top: 8),
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dashboardController.filteredCars.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => CarDetailView(car: dashboardController.filteredCars.value[index]));
                          },
                          child: CarItemCard(
                            carController: dashboardController,
                            carItem: dashboardController.filteredCars[index],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(),
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

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 30, 20),
        child: GNav(
          color: Colors.white,
          activeColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
          tabBackgroundColor: Colors.black,
          gap: 8,
          onTabChange: (index) {
            print(index);
          },
          padding: const EdgeInsets.all(16),
          tabs: const [
            GButton(
              icon: Icons.car_rental,
              text: "Ana Sayfa",
            ),
            GButton(
              icon: Icons.home,
              text: "Araçlarım",
            ),
            GButton(
              icon: Icons.person,
              text: "Profil",
            ),
            GButton(
              icon: Icons.person,
              text: "Profil",
            ),
          ],
        ),
      ),
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

class CarItemCard extends StatelessWidget {
  const CarItemCard({
    super.key,
    required this.carController,
    required this.carItem,
  });

  final DashboardController carController;
  final CarItem carItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: AppColors.primaryColor,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Stack(
              children: [
                Image.network(
                  carItem.photos.first,
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
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "${carItem.dailyPrice.toStringAsFixed(2)} ₺",
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${carItem.brand} ${carItem.brandModel}",
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
                          const Text("Km", style: TextStyle(fontWeight: FontWeight.w500)),
                          Text(
                            "${carItem.kilometer} Km",
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
                          Image.asset("assets/pngs/model.png", height: 20, width: 20, fit: BoxFit.contain),
                          const Text("Model", style: TextStyle(fontWeight: FontWeight.w500)),
                          Text(
                            carItem.year,
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
                          Image.asset("assets/pngs/transmission.png", height: 20, width: 20, fit: BoxFit.contain),
                          const Text("vites", style: TextStyle(fontWeight: FontWeight.w500)),
                          Text(
                            carItem.tranmission,
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
                          const Text("Yakıt", style: TextStyle(fontWeight: FontWeight.w500)),
                          Text(
                            carItem.fuelType,
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

  const MyCustomButton({required this.destination, required this.label});

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

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            CarCategoryButton(
              id: 1,
              title: "Otomobil",
              iconName: "car",
            ),
          ],
        ),
      ),
    );
  }
}
