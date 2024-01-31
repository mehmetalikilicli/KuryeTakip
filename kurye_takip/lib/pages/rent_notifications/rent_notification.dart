// ignore_for_file: prefer_const_constructors_in_immutables, prefer_is_empty, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/helpers/get_local_user_id.dart';
import 'package:kurye_takip/model/car_detail.dart';
import 'package:kurye_takip/pages/rent_notifications/rent_notification_detail.dart';
import 'package:kurye_takip/pages/rent_notifications/rent_notifications_controller.dart';
import 'package:kurye_takip/service/api_service.dart';

class RentNotificationPage extends StatelessWidget {
  RentNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RentNotificationsController controller = Get.put(RentNotificationsController());

    return Scaffold(
      appBar: AppBar(title: const Text("Taleplerim"), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height,
              child: FutureBuilder(
                future: controller.fetchRentNotifications(getLocalUserID()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Hata!"));
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator(color: Colors.black));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: controller.rentRequestNotification.notifications.length == 0
                          ? Center(child: Text("Herhangi bir talebiniz bulunmamaktadır."))
                          : ListView(
                              children: [
                                const Text("Taleplerim", style: TextStyle(fontSize: 32)),
                                const Divider(height: 2, color: Colors.black),
                                ListView.separated(
                                  padding: const EdgeInsets.only(top: 8),
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.rentRequestNotification.notifications.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          ListTile(
                                            onTap: () async {
                                              try {
                                                CarDetail carDetail = await ApiService.getCar(controller.rentRequestNotification.notifications[index].carId);
                                                Get.to(
                                                  RentNotificationDetail(carElement: carDetail.car!, index: index),
                                                );
                                              } catch (e) {
                                                log("Bildirim detayı getirilirken hata oluştur $e", name: "Bildirim detay hatası");
                                              }
                                            },
                                            title: Text(
                                                "${controller.rentRequestNotification.notifications[index].brandName ?? ""} - ${controller.rentRequestNotification.notifications[index].modelName ?? ""}"),
                                            subtitle: controller.rentRequestNotification.notifications[index].rentStatus == 0
                                                ? Row(
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets.all(8.0),
                                                          decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                                                          child: Text("Bekliyor", style: TextStyle(color: Colors.white))),
                                                    ],
                                                  )
                                                : controller.rentRequestNotification.notifications[index].rentStatus == 1
                                                    ? Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.all(8.0),
                                                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                            child: Text("Onaylandı", style: TextStyle(color: Colors.white)),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.all(8.0),
                                                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
                                                            child: Text("Reddedildi", style: TextStyle(color: Colors.white)),
                                                          ),
                                                        ],
                                                      ),
                                            trailing: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Icon(Icons.arrow_forward_ios_sharp),
                                                Text(
                                                  DateFormat('DD.MM.yyyy HH:mm').format(controller.rentRequestNotification.notifications[index].createdDate),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) => const Divider(height: 8),
                                ),
                              ],
                            ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
