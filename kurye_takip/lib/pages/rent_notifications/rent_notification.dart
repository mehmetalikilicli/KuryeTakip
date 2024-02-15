// ignore_for_file: prefer_const_constructors_in_immutables, prefer_is_empty, prefer_const_constructors, invalid_use_of_protected_member, use_build_context_synchronously, must_be_immutable, no_leading_underscores_for_local_identifiers, unnecessary_string_interpolations, unused_local_variable

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
import 'package:kurye_takip/helpers/get_local_user_id.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/cars_detail/car_detail.dart';
import 'package:kurye_takip/pages/payment/payment.dart';
import 'package:kurye_takip/pages/rent_notifications/rent_notifications_controller.dart';
import 'package:kurye_takip/pages/widgets/inputs.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
      body: RenterRequestList(),
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
                            onTap: () async {
                              try {
                                await controller.getNotificationDetail(index);
                              } catch (e) {
                                log("Bildirim detayı getirilirken hata oluştur $e", name: "Bildirim detay hatası");
                              }
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                                  onTap: () async {
                                    try {
                                      controller.getNotificationDetail(index);
                                    } catch (e) {
                                      log("Bildirim detayı getirilirken hata oluştur $e", name: "Bildirim detay hatası");
                                    }
                                  },
                                  title: Text(
                                    "${controller.rentRequestNotification.notifications[index].brandName ?? ""} - ${controller.rentRequestNotification.notifications[index].modelName ?? ""}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: controller.rentRequestNotification.notifications[index].rentStatus == 0
                                      ? Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6.0)),
                                                child: Text("Bekliyor", style: TextStyle(color: Colors.white, fontSize: 14))),
                                          ],
                                        )
                                      : controller.rentRequestNotification.notifications[index].rentStatus == 1
                                          ? Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(6.0)),
                                                  child: Text("Onaylandı", style: TextStyle(color: Colors.white, fontSize: 14)),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6.0)),
                                                  child: Text("Reddedildi", style: TextStyle(color: Colors.white, fontSize: 14)),
                                                ),
                                              ],
                                            ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(Icons.keyboard_arrow_right_rounded),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Talep oluşturma zamanı:", style: TextStyle(fontSize: 8)),
                                          Text("${DateFormat('dd.MM.yyyy HH:mm').format(controller.rentRequestNotification.notifications[index].createdDate)}"),
                                        ],
                                      )
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

class RenterRequestDetail extends StatelessWidget {
  RenterRequestDetail({super.key});

  final RentNotificationsController controller = Get.put(RentNotificationsController());

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

    return Scaffold(
      appBar: AppBar(),
      body: DefaultTabController(
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
                                  Icon(CupertinoIcons.mail),
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
                                  Icon(CupertinoIcons.timer),
                                  const SizedBox(width: 8),
                                  Text("${DateFormat('dd.MM.yyyy HH:mm').format(controller.selectedNotification!.createdDate)} ",
                                      style: TextStyle(fontSize: 16))
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
                                child: Obx(
                                  () => Column(
                                    children: [
                                      controller.isRenterLoadBeforePhoto.value == 1
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    await controller.fillPhotos(1, 0);
                                                    _showImagesFullScreenSlider();
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
                                                await controller.getPhotoPage(1, 0);
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
                              ),
                              SizedBox(height: 8),
                              Visibility(
                                visible: controller.selectedNotification!.rentStatus == 1 && controller.selectedNotification!.paymentStatus == 1,
                                child: Obx(
                                  () => Column(
                                    children: [
                                      controller.isRenterLoadAfterPhoto.value == 1
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    await controller.fillPhotos(1, 1);
                                                    _showImagesFullScreenSlider();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                    child: Text("Kiralama Sonrası Fotoğraflar", style: TextStyle(color: Colors.white)),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                await controller.getPhotoPage(1, 1);
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
                                          title: const Text("Aracı Değerlendir"),
                                          content: Form(
                                            key: controller.commentCarPageKey,
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
                                                    decoration: InputWidgets().noteDecoration(Colors.grey, Colors.red, "")),
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
                                                GeneralResponse generalResponse = await controller.GiveCarComment();
                                                if (generalResponse.success) {
                                                  CustomDialog.showMessage(context: context, title: "Değerlendirme", message: "Değerlendirmeniz kaydedildi.");
                                                  Get.back();
                                                } else {
                                                  CustomDialog.showMessage(
                                                      context: context, title: "Değerlendirme", message: "Değerlendirmeniz kaydedilemedi.");
                                                  Get.back();
                                                }
                                                await controller.GiveCarComment();
                                              },
                                              child: const Text("Değerlendir"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Visibility(
                                    visible: controller.isRenterLoadAfterPhoto.value == 1 && controller.isRenterLoadBeforePhoto.value == 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10.0)),
                                          child: Text("Aracı Değerlendir", style: TextStyle(color: Colors.black)),
                                        ),
                                      ],
                                    ),
                                  ),
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
                        carElement: controller.carElement,
                        isfloatingActionButtonActive: false,
                        isAppBarActive: false,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RenterAddRentPhoto extends StatelessWidget {
  RenterAddRentPhoto({super.key});

  final RentNotificationsController controller = Get.put(RentNotificationsController());

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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: () async {
                      //0 -> from owner, 0 -> before rent
                      if (await controller.saveRentCarPhotos(controller.carElement, controller.photoFrom, controller.rentType)) {
                        CustomDialog.showMessage(context: context, message: "Araç fotoğrafları yüklendi");
                        Get.back();
                      }
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
