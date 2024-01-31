// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/pages/cars_detail/car_detail.dart';
import 'package:kurye_takip/pages/rent_notifications/rent_notifications_controller.dart';

class RentNotificationDetail extends StatefulWidget {
  RentNotificationDetail({
    super.key,
    required this.carElement,
    required this.index,
  });

  CarElement carElement;
  int index;

  @override
  State<RentNotificationDetail> createState() => _RentNotificationDetailState();
}

class _RentNotificationDetailState extends State<RentNotificationDetail> {
  final RentNotificationsController controller = Get.put(RentNotificationsController());

  @override
  void initState() {
    super.initState();
    controller.fetchOwnerUser(widget.carElement.userId!);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Araç Sahibi Bilgileri"),
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
                            Row(
                              children: [
                                Icon(CupertinoIcons.timer_fill),
                                const SizedBox(width: 8),
                                Text("${DateFormat('DD.MM.yyyy HH:mm').format(controller.rentRequestNotification.notifications[widget.index].createdDate)} ",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.person_add),
                                const SizedBox(width: 8),
                                Text(
                                    "${controller.rentRequestNotification.notifications[widget.index].ownerName} ${controller.rentRequestNotification.notifications[widget.index].ownerSurname}",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.mail_solid),
                                const SizedBox(width: 8),
                                Text("${controller.rentRequestNotification.notifications[widget.index].ownerEmail} ", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.phone_arrow_right),
                                const SizedBox(width: 8),
                                Text("${controller.rentRequestNotification.notifications[widget.index].ownerPhone} ", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        controller.rentRequestNotification.notifications[widget.index].rentStatus == 0
                            ? Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                                      child: Text("Bekliyor", style: TextStyle(color: Colors.white))),
                                ],
                              )
                            : controller.rentRequestNotification.notifications[widget.index].rentStatus == 1
                                ? Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                        child: Text("Ödemeye Geç", style: TextStyle(color: Colors.white)),
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
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
