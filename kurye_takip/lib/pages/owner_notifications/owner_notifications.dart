// ignore_for_file: unused_import, prefer_is_empty, use_build_context_synchronously, prefer_const_constructors, unused_local_variable, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/helpers/get_local_user_id.dart';
import 'package:kurye_takip/main.dart';
import 'package:kurye_takip/model/car_detail.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/cars_detail/car_detail.dart';
import 'package:kurye_takip/pages/zzz/owner_notification_detail.dart';
import 'package:kurye_takip/pages/owner_notifications/owner_notifications_controller.dart';
import 'package:kurye_takip/service/api_service.dart';

class OwnerNotificationsPage extends StatelessWidget {
  OwnerNotificationsPage({super.key});

  final OwnerNotificationsController controller = Get.put(OwnerNotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Araç Kiralama İstekleri",
          ),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          centerTitle: true),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: const [
          OwnerRequestList(),
          OwnerRequestDetail(),
          OwnerAddRentPhoto(),
        ],
      ),
    );
  }
}

class OwnerRequestList extends GetView<OwnerNotificationsController> {
  const OwnerRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                                          controller.getNotificationDetail(index);
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
                                                  child: const Text("Bekliyor", style: TextStyle(color: Colors.white)),
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
                                            DateFormat('dd.MM.yyyy HH:mm').format(controller.rentRequestNotification.notifications[index].createdDate),
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
    );
  }
}

class OwnerRequestDetail extends GetView<OwnerNotificationsController> {
  const OwnerRequestDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          tabs: const [
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
                            Text("Kiralamak İsteyen Bilgileri", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Divider(height: 8, color: Colors.black),
                            Row(
                              children: [
                                Icon(CupertinoIcons.person_add),
                                const SizedBox(width: 8),
                                Text("${controller.selectedNotification!.renterName} ${controller.selectedNotification!.renterSurname}",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.mail_solid),
                                const SizedBox(width: 8),
                                Text("${controller.selectedNotification!.renterEmail} ", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(CupertinoIcons.phone_arrow_right),
                                const SizedBox(width: 8),
                                Text("${controller.selectedNotification!.renterPhone} ", style: TextStyle(fontSize: 16)),
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
                            controller.notificationApproveList[controller.detailIndex] == 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await showNotificationMessage(
                                              context: context,
                                              index: controller.detailIndex,
                                              message: "Aracınızı bu kullanıcıya kiraya vermek istiyor musunuz?");
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                                            child: Text("Onayınız Bekleniyor", style: TextStyle(color: Colors.white))),
                                      ),
                                    ],
                                  )
                                : controller.notificationApproveList[controller.detailIndex] == 1
                                    ? Align(
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                //await showNotificationMessage(context: context, index: widget.index, message: "Reddetmek istiyor musunuz?");
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                child: Text("Onayladınız", style: TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  color: controller.selectedNotification!.paymentStatus == 1 ? Colors.green : Colors.grey,
                                                  borderRadius: BorderRadius.circular(10.0)),
                                              child: Text(controller.selectedNotification!.paymentStatus == 1 ? "Ödendi" : "Ödenmedi",
                                                  style: TextStyle(color: Colors.white)),
                                            ),
                                            SizedBox(height: 8),
                                            Visibility(
                                              visible: controller.selectedNotification!.paymentStatus == 1,
                                              child: Column(
                                                children: [
                                                  controller.isOwnerLoadBeforePhoto.value == 1
                                                      ? Container(
                                                          padding: EdgeInsets.all(8.0),
                                                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                          child: Text("Kiralama Öncesi Fotoğraflar", style: TextStyle(color: Colors.white)),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () async {
                                                            controller.getPhotoPage(0, 0);
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.all(8.0),
                                                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                            child: Text("Kiralama Öncesi Fotoğrafları Yükleyiniz", style: TextStyle(color: Colors.white)),
                                                          ),
                                                        ),
                                                ],
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
                                              //await showNotificationMessage(context: context, index: widget.index, message: "Onaylamak istiyor musunuz?");
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
                                              child: Text("Reddettiniz", style: TextStyle(color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: controller.selectedNotification!.paymentStatus == 1 &&
                                      controller.selectedNotification!.rentEndDate.isAfter(DateTime.now()),
                                  child: Column(
                                    children: [
                                      controller.isOwnerLoadAfterPhoto.value == 1
                                          ? Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                              child: Text("Kiralama Sonrası Fotoğraflar", style: TextStyle(color: Colors.white)),
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                controller.getPhotoPage(0, 1);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                child: Text("Kiralama Sonrası Fotoğrafları Yükleyiniz", style: TextStyle(color: Colors.white)),
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
                  child: CarDetailView(carElement: controller.carElement, isfloatingActionButtonActive: false, isAppBarActive: false),
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

class OwnerAddRentPhoto extends GetView<OwnerNotificationsController> {
  const OwnerAddRentPhoto({super.key});

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
                                  base64Decode(controller.carImages[index].photo64),
                                  width: Get.width * 0.25,
                                  fit: BoxFit.fitWidth,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(controller.carImages[index].header, style: const TextStyle(fontWeight: FontWeight.w600))),
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
