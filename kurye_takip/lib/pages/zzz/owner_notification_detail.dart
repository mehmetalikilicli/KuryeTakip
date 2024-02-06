// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable
/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/pages/add_rent_photo/add_rent_photo.dart';
import 'package:kurye_takip/pages/cars_detail/car_detail.dart';
import 'package:kurye_takip/pages/owner_notifications/owner_notifications_controller.dart';
import 'package:kurye_takip/service/api_service.dart';

class OwnerNotificationDetail extends StatefulWidget {
  OwnerNotificationDetail({
    super.key,
    required this.carElement,
    required this.index,
  });

  CarElement carElement;
  int index;

  @override
  State<OwnerNotificationDetail> createState() => _OwnerNotificationDetailState();
}

class _OwnerNotificationDetailState extends State<OwnerNotificationDetail> {
  final OwnerNotificationsController controller = Get.put(OwnerNotificationsController());

  @override
  void initState() {
    controller.fetchRenterUser(widget.carElement.userId!);
    controller.index = widget.index;
    controller.carElement = widget.carElement;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Kiralama Bilgileri"),
              Tab(text: "Araç Bilgileri"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Kiralamak İsteyen Bilgileri", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Divider(height: 8, color: Colors.black),
                            Row(
                              children: [
                                Icon(CupertinoIcons.person_add),
                                const SizedBox(width: 8),
                                Text(
                                    "${controller.rentRequestNotification.notifications[widget.index].renterName} ${controller.rentRequestNotification.notifications[widget.index].renterSurname}",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.mail_solid),
                                const SizedBox(width: 8),
                                Text("${controller.rentRequestNotification.notifications[widget.index].renterEmail} ", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.phone_arrow_right),
                                const SizedBox(width: 8),
                                Text("${controller.rentRequestNotification.notifications[widget.index].renterPhone} ", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text("Kiralama Detayları", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Divider(height: 8, color: Colors.black),
                            Row(
                              children: [
                                Icon(CupertinoIcons.timer_fill),
                                const SizedBox(width: 8),
                                Text("${DateFormat('dd.MM.yyyy HH:mm').format(controller.rentRequestNotification.notifications[widget.index].createdDate)} ",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.calendar_today),
                                const SizedBox(width: 8),
                                Text(
                                    "${DateFormat('dd.MM.yyyy').format(controller.rentRequestNotification.notifications[widget.index].rentStartDate)} - ${DateFormat('dd.MM.yyyy').format(controller.rentRequestNotification.notifications[widget.index].rentEndDate)}",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.calendar_today),
                                const SizedBox(width: 8),
                                Text("${controller.rentRequestNotification.notifications[widget.index].price} ₺", style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        controller.rentRequestNotification.notifications[widget.index].rentStatus == 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await showNotificationMessage(
                                          context: context, index: widget.index, message: "Aracınızı bu kullanıcıya kiraya vermek istiyor musunuz?");
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                                        child: Text("Onayınız Bekleniyor", style: TextStyle(color: Colors.white))),
                                  ),
                                ],
                              )
                            : controller.rentRequestNotification.notifications[widget.index].rentStatus == 1
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              color: controller.rentRequestNotification.notifications[widget.index].paymentStatus == 1
                                                  ? Colors.green
                                                  : Colors.grey,
                                              borderRadius: BorderRadius.circular(10.0)),
                                          child: Text(controller.rentRequestNotification.notifications[widget.index].paymentStatus == 1 ? "Ödendi" : "Ödenmedi",
                                              style: TextStyle(color: Colors.white)),
                                        ),
                                        SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () async {
                                            await showNotificationMessage(context: context, index: widget.index, message: "Reddetmek istiyor musunuz?");
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                            child: Text("Onayladınız", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () async {
                                            Get.to(
                                              AddRentPhoto(
                                                carElement: widget.carElement,
                                                photo_from: 0,
                                                rent_type: 0,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                            child: Text("Fotoğrafları Yükleyiniz", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await showNotificationMessage(context: context, index: widget.index, message: "Onaylamak istiyor musunuz?");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
                                          child: Text("Reddettiniz", style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: Get.height * 0.9,
                  width: Get.width,
                  child: CarDetailView(
                    carElement: widget.carElement,
                    isfloatingActionButtonActive: false,
                    isAppBarActive: false,
                  ),
                ),
              ),
            ),
          ],
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
*/