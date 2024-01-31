// ignore_for_file: prefer_const_constructors, prefer_is_empty, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/pages/my_cars/my_cars_controller.dart';
import 'package:kurye_takip/pages/my_cars_detail/my_cars_detail.dart';

class MyCarsPage extends StatelessWidget {
  MyCarsPage({super.key});

  final MyCarsController controller = Get.put(MyCarsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Araçlarım"),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Hata!"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator(color: Colors.black));
            } else {
              return controller.cars.cars.length == 0
                  ? Center(child: Text("Herhangi bir aracınız bulunmamaktadır."))
                  : ListView.separated(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: controller.cars.cars.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                              onTap: () async {
                                try {
                                  Get.to(MyCarsDetailPage(carElement: controller.cars.cars[index]));
                                } catch (e) {
                                  log("Bildirim detayı getirilirken hata oluştur $e", name: "Bildirim detay hatası");
                                }
                              },
                              title: Text(
                                "${controller.cars.cars[index].brandName ?? ""} - ${controller.cars.cars[index].modelName ?? ""} - ${controller.cars.cars[index].plate ?? ""}",
                              ),
                              subtitle: controller.cars.cars[index].isActive == 0
                                  ? Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6.0)),
                                          child: Text("Yayında Değil", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(6.0)),
                                          child: Text("Yayında", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                              leading: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  width: Get.width * 0.24,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                  child: Image.network(
                                    controller.cars.cars[index].carAddPhotos![0].photoPath,
                                    fit: BoxFit.cover,
                                    width: Get.width - 8,
                                  ),
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(height: 0),
                    );
            }
          },
        ),
      ),
    );
  }
}
