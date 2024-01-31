// ignore_for_file: unused_import, prefer_is_empty, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/helpers/get_local_user_id.dart';
import 'package:kurye_takip/main.dart';
import 'package:kurye_takip/model/car_detail.dart';
import 'package:kurye_takip/pages/cars_detail/car_detail.dart';
import 'package:kurye_takip/pages/owner_notifications/owner_notification_detail.dart';
import 'package:kurye_takip/pages/owner_notifications/owner_notifications_controller.dart';
import 'package:kurye_takip/service/api_service.dart';

class OwnerNotificationsPage extends StatelessWidget {
  OwnerNotificationsPage({super.key});

  final OwnerNotificationsController controller = Get.put(OwnerNotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Araç Kiralama Talepleri"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.height,
                child: FutureBuilder(
                  future: controller.fetchOwnerNotifications(getLocalUserID()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Hata!"));
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CupertinoActivityIndicator(color: Colors.black));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: controller.notificationApproveList.length == 0
                            ? const Center(child: Text("Herhangi bir isteğiniz bulunmamaktadır."))
                            : ListView(
                                children: [
                                  const Text("İsteklerim", style: TextStyle(fontSize: 32)),
                                  const Divider(height: 2, color: Colors.black),
                                  ListView.separated(
                                    padding: const EdgeInsets.only(top: 8),
                                    shrinkWrap: true,
                                    primary: false,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: controller.notificationApproveList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Obx(
                                        () => GestureDetector(
                                          onTap: () {},
                                          child: Column(
                                            children: [
                                              ListTile(
                                                onTap: () async {
                                                  try {
                                                    CarDetail carDetail =
                                                        await ApiService.getCar(controller.rentRequestNotification.notifications[index].carId);
                                                    showNotificationMessage(
                                                      context: context,
                                                      index: index,
                                                      message: "${carDetail.car!.userName} aracınızı kiralamak istiyor.",
                                                    );
                                                  } catch (e) {
                                                    log("Bildirim detayı getirilirken hata oluştur $e", name: "Bildirim detay hatası");
                                                  }
                                                },
                                                title: Text(
                                                    "${controller.rentRequestNotification.notifications[index].brandName ?? ""} - ${controller.rentRequestNotification.notifications[index].modelName ?? ""} - ${controller.rentRequestNotification.notifications[index].plate}"),
                                                subtitle: controller.notificationApproveList[index] == 0
                                                    ? Row(
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.all(8.0),
                                                            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                                                            child: const Text("Bekliyor", style: TextStyle(color: Colors.black)),
                                                          ),
                                                        ],
                                                      )
                                                    : controller.notificationApproveList[index] == 1
                                                        ? Row(
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets.all(8.0),
                                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                                child: const Text("Onayladınız", style: TextStyle(color: Colors.white)),
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets.all(8.0),
                                                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
                                                                child: const Text("Reddettiniz", style: TextStyle(color: Colors.white)),
                                                              ),
                                                            ],
                                                          ),
                                                trailing: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    const Icon(Icons.arrow_forward_ios_sharp),
                                                    Text(
                                                      DateFormat('DD-MM-yyyy HH:mm')
                                                          .format(controller.rentRequestNotification.notifications[index].createdDate),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
      ),
    );
  }

  Future<void> showNotificationMessage({
    BuildContext? context,
    String? title,
    String? message,
    String? positiveButtonText,
    String? negativeButtonText,
    int index = 0,
  }) async {
    return showDialog<void>(
      context: context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: message != null ? Text(message) : null,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(negativeButtonText ?? 'Vazgeç'),
            ),
            TextButton(
              onPressed: () {
                ApiService.ApproveOrRejectNotification(controller.rentRequestNotification.notifications[index].ID, 2);
                controller.notificationApproveList[index] = 2;
                Get.back();
              },
              child: Text(negativeButtonText ?? 'Reddet'),
            ),
            TextButton(
              onPressed: () {
                ApiService.ApproveOrRejectNotification(controller.rentRequestNotification.notifications[index].ID, 1);
                controller.notificationApproveList[index] = 1;

                Get.back();
              },
              child: Text(positiveButtonText ?? 'Onayla'),
            ),
          ],
        );
      },
    );
  }
}
