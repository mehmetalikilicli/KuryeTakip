// ignore_for_file: prefer_const_constructors_in_immutables, prefer_is_empty, prefer_const_constructors, invalid_use_of_protected_member, use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/helpers/get_local_user_id.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/cars_detail/car_detail.dart';
import 'package:kurye_takip/pages/payment/payment.dart';
import 'package:kurye_takip/pages/rent_notifications/rent_notifications_controller.dart';

class RentNotificationPage extends StatelessWidget {
  RentNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RentNotificationsController controller = Get.put(RentNotificationsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Taleplerim"),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: const [
          RenterRequestList(),
          RenterRequestDetail(),
          RenterAddRentPhoto(),
        ],
      ),
    );
  }
}

class RenterRequestList extends GetView<RentNotificationsController> {
  const RenterRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.fetchRentNotifications(getLocalUserID()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Hata!"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.black));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: controller.notificationApproveList.length == 0
                ? Center(child: Text("Herhangi bir talebiniz bulunmamaktadır."))
                : ListView(
                    children: [
                      ListView.separated(
                        padding: const EdgeInsets.only(top: 8),
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.notificationApproveList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              try {
                                controller.getNotificationDetail(index);
                              } catch (e) {
                                log("Bildirim detayı getirilirken hata oluştur $e", name: "Bildirim detay hatası");
                              }
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () async {
                                    try {
                                      controller.getNotificationDetail(index);
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
                                        DateFormat('dd.MM.yyyy HH:mm').format(controller.rentRequestNotification.notifications[index].createdDate),
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
    );
  }
}

class RenterRequestDetail extends GetView<RentNotificationsController> {
  const RenterRequestDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const TabBar(
          tabs: [
            Tab(text: "Kiralama Bilgileri"),
            Tab(text: "Araç Bilgileri"),
          ],
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
                            Text("Araç Sahibi Bilgileri", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Divider(height: 8, color: Colors.black),
                            Row(
                              children: [
                                Icon(CupertinoIcons.person_add),
                                const SizedBox(width: 8),
                                Text("${controller.selectedNotification!.ownerName} ${controller.selectedNotification!.ownerSurname}",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.mail_solid),
                                const SizedBox(width: 8),
                                Text("${controller.selectedNotification!.ownerEmail} ", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.phone_arrow_right),
                                const SizedBox(width: 8),
                                Text("${controller.selectedNotification!.ownerPhone} ", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text("Kiralama Detayları", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Divider(height: 8, color: Colors.black),
                            Row(
                              children: [
                                Icon(CupertinoIcons.timer_fill),
                                const SizedBox(width: 8),
                                Text("${DateFormat('dd.MM.yyyy HH:mm').format(controller.selectedNotification!.createdDate)} ", style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.calendar_today),
                                const SizedBox(width: 8),
                                Text(
                                    "${DateFormat('dd.MM.yyyy').format(controller.selectedNotification!.rentStartDate)} - ${DateFormat('dd.MM.yyyy').format(controller.selectedNotification!.rentEndDate)}",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.calendar_today),
                                const SizedBox(width: 8),
                                Text("${controller.selectedNotification!.price} ₺", style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            controller.selectedNotification!.rentStatus == 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                                          child: Text("Araç sahibinin onayı bekleniyor", style: TextStyle(color: Colors.white))),
                                    ],
                                  )
                                : controller.selectedNotification!.rentStatus == 1
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(PaymentPage(carElement: controller.carElement, rentNotification: controller.selectedNotification!));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                              child: Text(controller.selectedNotification!.paymentStatus == 0 ? "Ödemeye Geç" : "Ödediniz",
                                                  style: TextStyle(color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
                                            child: Text("Reddedildi", style: TextStyle(color: Colors.white)),
                                          ),
                                        ],
                                      ),
                            SizedBox(height: 8),
                            Visibility(
                              visible: controller.selectedNotification!.rentStatus == 1 && controller.selectedNotification!.paymentStatus == 1,
                              child: Column(
                                children: [
                                  controller.isRenterLoadBeforePhoto.value == 1
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(GetRentPhotosPage(
                                                  title: "",
                                                ));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                child: Text("Kiralama Öncesi Fotoğraflar", style: TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            controller.getPhotoPage(1, 0);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                child: Text("Kiralama Öncesi Fotoğrafları Yükleyiniz", style: TextStyle(color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Visibility(
                              visible: controller.selectedNotification!.rentStatus == 1 && controller.selectedNotification!.paymentStatus == 1,
                              child: Column(
                                children: [
                                  controller.isRenterLoadAfterPhoto.value == 1
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                              child: Text("Kiralama Sonrası Fotoğraflar", style: TextStyle(color: Colors.white)),
                                            ),
                                          ],
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            controller.getPhotoPage(1, 1);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                child: Text("Kiralama Sonrası Fotoğrafları Yükleyiniz", style: TextStyle(color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                onPressed: () {
                                  controller.pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                                },
                                child: const Text("Geri"),
                              ),
                            ),
                            /*Align(
                                  alignment: Alignment.center,
                                  child: MaterialButton(
                                    color: AppColors.primaryColor,
                                    minWidth: Get.width / 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () {
                                      controller.pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                                    },
                                    child: const Text("İleri", style: TextStyle(color: Colors.white)),
                                  ),
                                ),*/
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
                      carElement: controller.carElement,
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

class RenterAddRentPhoto extends GetView<RentNotificationsController> {
  const RenterAddRentPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              itemCount: controller.carAddImages.length,
              separatorBuilder: (context, index) => const Divider(height: 12),
              itemBuilder: (BuildContext context, int index) {
                return Obx(
                  () => Column(
                    children: [
                      Row(
                        children: controller.carAddImages.value[index].load.isFalse
                            ? [
                                Expanded(child: Text(controller.carAddImages.value[index].description)),
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
                                  base64Decode(controller.carAddImages[index].photo64),
                                  width: Get.width * 0.25,
                                  fit: BoxFit.fitWidth,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(controller.carAddImages[index].header, style: const TextStyle(fontWeight: FontWeight.w600))),
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
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    controller.pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                  },
                  child: const Text("Geri"),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () async {
                    //0 -> from owner, 0 -> before rent
                    if (await controller.saveRentCarPhotos(controller.carElement, controller.photoFrom, controller.rentType)) {
                      CustomDialog.showMessage(context: context, title: "Fotoğraflar Kaydedildi", message: "Fotoğraflar başarıyla kaydedildi.");
                      Get.back();
                    } else {}
                  },
                  child: const Text("Kaydet"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GetRentPhotosPage extends GetView<RentNotificationsController> {
  GetRentPhotosPage({super.key, required this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: Text("Fotoğraf ismi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            Divider(height: 12),
            Obx(
              () => ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
