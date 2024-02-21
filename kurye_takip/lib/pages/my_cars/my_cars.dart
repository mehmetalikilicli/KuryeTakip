// ignore_for_file: prefer_const_constructors, prefer_is_empty, prefer_const_literals_to_create_immutables, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/my_cars/my_cars_controller.dart';
import 'package:kurye_takip/pages/my_cars_detail/my_cars_detail.dart';

class MyCarsPage extends StatelessWidget {
  MyCarsPage({super.key});

  final MyCarsController controller = Get.put(MyCarsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Araçlarım"),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        shadowColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
              future: controller.fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Hata!"));
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator(color: Colors.black));
                } else {
                  return controller.carList.value.length == 0
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Bir aracınız bulunmamaktadır."),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.green.shade800,
                                        visualDensity: VisualDensity.compact,
                                        side: BorderSide(
                                          color: controller.isActive.value == 0 ? Colors.green.shade800 : Colors.red.shade800,
                                        ),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      onPressed: () {
                                        Get.to(() => TestAddCarView());
                                      },
                                      child: Row(
                                        children: [
                                          Icon(CupertinoIcons.add_circled),
                                          SizedBox(width: 8),
                                          Text("Araç ekle"),
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Obx(
                          () => ListView.separated(
                            padding: const EdgeInsets.only(top: 8),
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.carList.value.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                    onTap: () async {
                                      try {
                                        await Get.to(MyCarsDetailPage(carElement: controller.carList.value[index]));
                                        controller.fetchData();
                                      } catch (e) {
                                        log("Bildirim detayı getirilirken hata oluştur $e", name: "Bildirim detay hatası");
                                      }
                                    },
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.carList.value[index].plate ?? "",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        Text(
                                          "${controller.carList.value[index].brandName ?? ""} - ${controller.carList.value[index].modelName ?? ""} ",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                          decoration: BoxDecoration(
                                              color: controller.carList.value[index].isActive == 0 ? Colors.red : Colors.green,
                                              borderRadius: BorderRadius.circular(6.0)),
                                          child: Text(
                                            controller.carList.value[index].isActive == 0 ? "Yayında Değil" : "Yayında",
                                            style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                    leading: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        width: Get.width * 0.24,
                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                        child: Image.network(
                                          controller.carList.value[index].carAddPhotos![0].photoPath,
                                          fit: BoxFit.cover,
                                          width: Get.width - 8,
                                        ),
                                      ),
                                    ),
                                    trailing: Icon(Icons.keyboard_arrow_right_rounded),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(height: 0),
                          ),
                        );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green.shade800,
                        visualDensity: VisualDensity.compact,
                        side: BorderSide(
                          color: controller.isActive.value == 0 ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Get.to(() => TestAddCarView());
                      },
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.add_circled),
                          SizedBox(width: 8),
                          Text("Araç ekle"),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
