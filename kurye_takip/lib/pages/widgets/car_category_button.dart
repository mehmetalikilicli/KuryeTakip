import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';

import '../dashboard/dashboard_controller.dart';

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
              color: controller.activeType.value == id ? AppColors.primaryColor : Colors.grey,
            ),

            foregroundColor: controller.activeType.value == id ? AppColors.primaryColor : Colors.grey,
          ),
          onPressed: () => controller.filter(id),
          child: Row(
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
