// ignore_for_file: invalid_use_of_protected_member, must_be_immutable, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/add_rent_photo/add_rent_photo_controller.dart';

class AddRentPhoto extends StatelessWidget {
  AddRentPhoto({
    super.key,
    required this.carElement,
    required this.photo_from,
    required this.rent_type,
  });

  CarElement carElement;
  int photo_from;
  int rent_type;

  final AddRentPhotoController controller = Get.put(AddRentPhotoController());

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
                itemCount: controller.carImages.length,
                separatorBuilder: (context, index) => const Divider(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  return Obx(
                    () => Column(
                      children: [
                        Row(
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
                                    onTap: () {},
                                    child: const Icon(CupertinoIcons.xmark_circle, color: CupertinoColors.systemRed),
                                  ),
                                ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () async {
                  if (await controller.saveRentCarPhotos(carElement, photo_from, rent_type)) {
                    CustomDialog.showMessage(context: context, title: "Fotoğraflar Kaydedildi", message: "Fotoğraflar başarıyla kaydedildi.");
                  } else {
                    CustomDialog.showMessage(context: context, title: "Fotoğraflar Kaydedilemedi", message: "Fotoğraflar kaydedilemedi.");
                  }
                },
                child: const Text("Kaydet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
