// ignore_for_file: unused_import, prefer_is_empty, use_build_context_synchronously, prefer_const_constructors, unused_local_variable, invalid_use_of_protected_member, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/helpers/get_local_user.dart';
import 'package:kurye_takip/main.dart';
import 'package:kurye_takip/model/car_detail.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/cars_detail/car_detail.dart';
import 'package:kurye_takip/pages/widgets/inputs.dart';
import 'package:kurye_takip/pages/zzz/owner_notification_detail.dart';
import 'package:kurye_takip/pages/owner_notifications/owner_notifications_controller.dart';
import 'package:kurye_takip/service/api_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class OwnerNotificationsPage extends StatelessWidget {
  OwnerNotificationsPage({super.key});

  final OwnerNotificationsController controller = Get.put(OwnerNotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Araç Kiralama İstekleri"),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        shadowColor: Colors.black,
      ),
      body: OwnerRequestList(),
    );
  }
}

class OwnerRequestList extends StatelessWidget {
  OwnerRequestList({super.key});

  final OwnerNotificationsController controller = Get.put(OwnerNotificationsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: controller.fetchOwnerNotifications(
          GetLocalUserInfo.getLocalUserID(),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Hata!"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator(color: Colors.black));
          } else {
            return Obx(
              () => controller.ONlist.length == 0
                  ? const Center(child: Text("Herhangi bir isteğiniz bulunmamaktadır."))
                  : ListView.separated(
                      padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.ONlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Obx(
                          () => GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                  onTap: () async {
                                    try {
                                      await controller.getNotificationDetail(index);
                                      Get.to(OwnerRequestDetail());
                                    } catch (e) {
                                      log("Bildirim detayı getirilirken hata oluştu $e", name: "Bildirim detay hatası");
                                    }
                                  },
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.rentRequestNotification.notifications[index].plate,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      Text(
                                        "${controller.rentRequestNotification.notifications[index].brandName ?? ""} - ${controller.rentRequestNotification.notifications[index].modelName ?? ""} ",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  subtitle: controller.ONlist[index].rentStatus.value == 0
                                      ? Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6.0)),
                                              child: const Text("Bekliyor", style: TextStyle(color: Colors.white, fontSize: 14)),
                                            ),
                                          ],
                                        )
                                      : controller.ONlist[index].rentStatus.value == 1
                                          ? Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(6.0)),
                                                  child: const Text("Onayladınız", style: TextStyle(color: Colors.white, fontSize: 14)),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6.0)),
                                                  child: const Text("Reddettiniz", style: TextStyle(color: Colors.white, fontSize: 14)),
                                                ),
                                              ],
                                            ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Icon(Icons.keyboard_arrow_right_rounded),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("No: ${controller.rentRequestNotification.notifications[index].ID.toString()}"),
                                          Text(DateFormat('dd.MM.yyyy HH:mm').format(controller.rentRequestNotification.notifications[index].createdDate)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(height: 0),
                    ),
            );
          }
        },
      ),
    );
  }
}

class OwnerRequestDetail extends StatelessWidget {
  OwnerRequestDetail({super.key});

  final OwnerNotificationsController controller = Get.put(OwnerNotificationsController());

  @override
  Widget build(BuildContext context) {
    void _showImagesFullScreenSlider() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Stack(
              children: [
                PhotoViewGallery.builder(
                  itemCount: controller.carShowImages.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(controller.carShowImages[index].path!),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  },
                  scrollPhysics: const BouncingScrollPhysics(),
                  backgroundDecoration: BoxDecoration(
                    color: Colors.grey.shade700.withOpacity(0.7),
                  ),
                  pageController: PageController(initialPage: 0),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.selectedNotification!.plate),
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
                    child: Obx(
                      () => Column(
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
                              Icon(CupertinoIcons.mail),
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
                          Row(
                            children: [
                              Icon(CupertinoIcons.star),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  RenterCommentBottomSheet.showComments(context: context, rentNotification: controller.selectedNotification!);
                                },
                                child: RatingBarIndicator(
                                  rating: controller.calculateAverageRating(),
                                  itemCount: 5,
                                  itemSize: 18.0,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              Text("(${controller.selectedNotification?.renterComment?.length ?? 0})"),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Kiralama Detayları", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Divider(height: 8, color: Colors.black),
                          Row(
                            children: [
                              Icon(CupertinoIcons.time),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  Text("İstek zamanı:"),
                                  SizedBox(width: 2),
                                  Text("${DateFormat('dd.MM.yyyy - HH:mm').format(controller.selectedNotification!.createdDate)} ",
                                      style: TextStyle(fontSize: 14))
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(CupertinoIcons.calendar_today),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  Text("İstek tarih aralığı: "),
                                  Text(
                                      "${DateFormat('dd.MM.yyyy').format(controller.selectedNotification!.rentStartDate)} - ${DateFormat('dd.MM.yyyy').format(controller.selectedNotification!.rentEndDate)}",
                                      style: TextStyle(fontSize: 14)),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(CupertinoIcons.tags),
                              const SizedBox(width: 8),
                              Text("Fiyat: "),
                              Text("${controller.selectedNotification!.price} ₺", style: TextStyle(fontSize: 16))
                            ],
                          ),
                          /*controller.selectedNotification!.renterNote != ""
                              ? Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    Row(
                                      children: const [
                                        Icon(Icons.note_outlined),
                                        SizedBox(width: 8),
                                        Text(
                                          "Kullanıcı notu:",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: SizedBox(
                                            height: Get.height * 0.1,
                                            child: SingleChildScrollView(
                                              padding: EdgeInsets.only(left: 4),
                                              child: Text(
                                                "\"${controller.selectedNotification!.renterNote}\"",
                                                style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Container(),*/
                          const SizedBox(height: 8),
                          Obx(
                            () => controller.ONlist.isNotEmpty && controller.ONlist[controller.selectedIndex].rentStatus.value == 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await showNotificationMessage(
                                              context: context,
                                              index: controller.selectedIndex,
                                              message: "Aracınızı bu kullanıcıya kiraya vermek istiyor musunuz?");
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                                            child: Text("Onayınız Bekleniyor", style: TextStyle(color: Colors.white))),
                                      ),
                                    ],
                                  )
                                : controller.ONlist.isNotEmpty && controller.ONlist[controller.selectedIndex].rentStatus.value == 1
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
                                                  color: controller.ONlist[controller.selectedIndex].paymentStatus.value == 1 ? Colors.green : Colors.grey,
                                                  borderRadius: BorderRadius.circular(10.0)),
                                              child: Text(controller.ONlist[controller.selectedIndex].paymentStatus.value == 1 ? "Ödendi" : "Ödenmedi",
                                                  style: TextStyle(color: Colors.white)),
                                            ),
                                            SizedBox(height: 8),
                                            Visibility(
                                              visible: controller.ONlist[controller.selectedIndex].paymentStatus.value == 1,
                                              child: Obx(
                                                () => Column(
                                                  children: [
                                                    controller.isOwnerLoadBeforePhoto.value == 1
                                                        ? GestureDetector(
                                                            onTap: () async {
                                                              await controller.fillPhotos(0, 0);
                                                              _showImagesFullScreenSlider();
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(8.0),
                                                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                              child: Text("Kiralama Öncesi Fotoğraflar", style: TextStyle(color: Colors.white)),
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () async {
                                                              await controller.getPhotoPage(0, 0);
                                                              Get.to(OwnerAddRentPhoto());
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
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: controller.ONlist.isNotEmpty &&
                                    controller.ONlist[controller.selectedIndex].paymentStatus.value == 1 &&
                                    controller.selectedNotification!.rentEndDate.isAfter(DateTime.now()),
                                child: Obx(
                                  () => Column(
                                    children: [
                                      controller.isOwnerLoadAfterPhoto.value == 1
                                          ? GestureDetector(
                                              onTap: () async {
                                                await controller.fillPhotos(1, 1);
                                                _showImagesFullScreenSlider();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                child: Text("Kiralama Sonrası Fotoğraflar", style: TextStyle(color: Colors.white)),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                controller.getPhotoPage(0, 1);
                                                Get.to(OwnerAddRentPhoto());
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
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Visibility(
                            visible: controller.isRentEnd == 0,
                            child: GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                      title: const Text(
                                        "Aracınızı kiralayan kişiyi değerlendirin",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      content: Form(
                                        key: controller.commentRenterPageKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Puan", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                                            RatingBar.builder(
                                              initialRating: 1,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (double rating) {
                                                controller.rating.value = rating;
                                              },
                                            ),
                                            const SizedBox(height: 8),
                                            const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Yorum", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                                            const Divider(height: 4),
                                            TextField(
                                                controller: controller.comment,
                                                keyboardType: TextInputType.multiline,
                                                maxLines: 6,
                                                decoration:
                                                    InputWidgets().noteDecoration(Colors.grey, Colors.red, "").copyWith(labelStyle: TextStyle(fontSize: 14))),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text("İptal"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            GeneralResponse generalResponse = await controller.GiveRenterComment();

                                            if (generalResponse.success) {
                                              CustomDialog.showMessage(context: context, title: "Değerlendirme", message: "Değerlendirmeniz kaydedildi.");
                                              Get.back();
                                            } else {
                                              CustomDialog.showMessage(context: context, title: "Değerlendirme", message: "Değerlendirmeniz kaydedilemedi.");
                                              Get.back();
                                            }
                                          },
                                          child: const Text("Değerlendir"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Visibility(
                                visible: controller.isOwnerLoadAfterPhoto.value == 1 && controller.isOwnerLoadBeforePhoto.value == 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10.0)),
                                      child: Text("Kullanıcıyı Değerlendir", style: TextStyle(color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
              onPressed: () async {
                GeneralResponse generalResponse = await ApiService.ApproveOrRejectNotification(controller.rentRequestNotification.notifications[index].ID, 2);
                if (generalResponse.success) {
                  controller.ONlist[index].rentStatus = 2.obs;
                  controller.fetchOwnerNotifications(
                    GetLocalUserInfo.getLocalUserID(),
                  );
                  Get.back();
                }
              },
              child: Text(negativeButtonText ?? 'Reddet'),
            ),
            TextButton(
              onPressed: () async {
                GeneralResponse generalResponse = await ApiService.ApproveOrRejectNotification(controller.rentRequestNotification.notifications[index].ID, 1);
                if (generalResponse.success) {
                  controller.ONlist[index].rentStatus = 1.obs;
                  controller.fetchOwnerNotifications(
                    GetLocalUserInfo.getLocalUserID(),
                  );
                  Get.back();
                }
              },
              child: Text(positiveButtonText ?? 'Onayla'),
            ),
          ],
        );
      },
    );
  }
}

class OwnerAddRentPhoto extends StatelessWidget {
  OwnerAddRentPhoto({super.key});

  final OwnerNotificationsController controller = Get.put(OwnerNotificationsController());

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
                padding: EdgeInsets.only(top: 8),
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
                                    onTap: () {
                                      controller.removeImageAtIndex(index);
                                    },
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: () async {
                      //0 -> from owner, 0 -> before rent
                      await controller.saveRentCarPhotos(controller.carElement, controller.photoFrom, controller.rentType);
                    },
                    child: const Text("Kaydet"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
