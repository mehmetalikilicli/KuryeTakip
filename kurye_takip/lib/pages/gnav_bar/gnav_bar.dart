import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/pages/gnav_bar/gnav_bar_controller.dart';

class GoogleNavBar extends StatelessWidget {
  const GoogleNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scaffold(
          body: Obx(
            () => bottomNavBarController.pages[bottomNavBarController.index.value],
          ),
          bottomNavigationBar: Container(
            color: AppColors.primaryColor,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: GNav(
                color: Colors.white,
                activeColor: Colors.white,
                backgroundColor: AppColors.primaryColor,
                tabBackgroundColor: Colors.grey.shade800,
                gap: 8,
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
                selectedIndex: bottomNavBarController.index.value,
                onTabChange: (index) {
                  bottomNavBarController.index.value = index;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
