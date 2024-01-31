// ignore_for_file: must_be_immutable, unnecessary_null_comparison, non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, unnecessary_brace_in_string_interps, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/helpers/custom_dialog.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/pages/cars_detail/car_detail_controller.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CarDetailView extends StatefulWidget {
  CarDetailView({
    super.key,
    required this.carElement,
    required this.isfloatingActionButtonActive,
    required this.isAppBarActive,
  });

  final CarElement carElement;
  final isfloatingActionButtonActive;
  bool isAppBarActive = true;

  @override
  State<CarDetailView> createState() => _CarDetailViewState();
}

class _CarDetailViewState extends State<CarDetailView> {
  final CarDetailController controller = Get.put(CarDetailController());

  @override
  void initState() {
    controller.FillCarPhotos(widget.carElement);
    controller.FillTheMarkers(widget.carElement.carAvailableLocations!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheCarPhotos(widget.carElement.carAddPhotos!);
    });
    super.initState();
  }

  void precacheCarPhotos(List<CarAddPhoto> carAddPhotos) {
    carAddPhotos.forEach((photo) {
      if (photo.photoPath != null) {
        precacheImage(NetworkImage(photo.photoPath), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    RxInt current = 0.obs;
    final CarImages = widget.carElement.carAddPhotos;

    final height = Get.height - 8;
    final width = Get.width - 8;

    return Scaffold(
      floatingActionButton: Visibility(
        visible: widget.isfloatingActionButtonActive,
        child: FloatingActionButton.extended(
          onPressed: () async {
            if (await controller.SendRentRequest(widget.carElement)) {
              // ignore: use_build_context_synchronously
              CustomDialog.showMessage(
                  context: context,
                  title: "Talep Gönderildi",
                  message: "Talep başarıyla gönderildi, talep cevabını \"Taleplerim\" sekmesinden takip edebilirisinz.",
                  onPositiveButtonPressed: () {});
            } else {
              // ignore: use_build_context_synchronously
              CustomDialog.showMessage(
                context: context,
                title: "Hata",
                message: "Talep gönderilemedi",
                onPositiveButtonPressed: () {},
              );
            }
          },
          label: const Text("Kiralama Talebi Gönder"),
          backgroundColor: AppColors.primaryColor,
        ),
      ),
      appBar: widget.isAppBarActive
          ? AppBar(
              title: Text(
                "${widget.carElement.brandName} - ${widget.carElement.modelName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
      body: Column(
        children: [
          CarSlider(
            widget: widget,
            current: current,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: CarDetailFeatured(
              height: height,
              width: width,
              widget: widget,
            ),
          ),
        ],
      ),
    );
  }
}

class CarDetailFeatured extends StatelessWidget {
  const CarDetailFeatured({
    super.key,
    required this.height,
    required this.width,
    required this.widget,
  });

  final double height;
  final double width;
  final CarDetailView widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: Container(
        //height: height * 0.5,
        width: width,
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarBrandAndBrandModelText(widget: widget),
                      const SizedBox(height: 6),
                      Text("${widget.carElement.dailyPrice}₺ / Günlük"),
                      const SizedBox(height: 20)
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.dialog(SeeAvailableTimes(
                            widget: widget,
                          ));
                        },
                        icon: const Icon(CupertinoIcons.timer, size: 32, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.dialog(const SeeAvailableLocaitons());
                        },
                        icon: const Icon(CupertinoIcons.location_circle, size: 32, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
              Center(child: Text(widget.carElement.note ?? "")),
              const SizedBox(height: 8),
              const Text(
                "Featured",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "year",
                          featuredTitle: "Yıl",
                          featuredData: "${widget.carElement.year}",
                        ),
                        const SizedBox(height: 4),
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "speedometer",
                          featuredTitle: "Kilometre",
                          featuredData: "${widget.carElement.km}",
                        ),
                        const SizedBox(height: 4),
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "price",
                          featuredTitle: "Ücret / Günlük",
                          featuredData: "${widget.carElement.dailyPrice} ₺",
                        ),
                        const SizedBox(height: 4),
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "weeklyDiscount",
                          featuredTitle: "İndirim/Haftalık",
                          featuredData: "%${widget.carElement.weeklyRent} ",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      children: [
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "price",
                          featuredTitle: "Ücret / Günlük",
                          featuredData: "${widget.carElement.dailyPrice} ₺",
                        ),
                        const SizedBox(height: 4),
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "speedometer",
                          featuredTitle: "Yakıt Tipi",
                          featuredData: "${widget.carElement.fuelType}",
                        ),
                        const SizedBox(height: 4),
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "speedometer",
                          featuredTitle: "Vites",
                          featuredData: "${widget.carElement.transmissionType}",
                        ),
                        const SizedBox(height: 4),
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "weeklyDiscount",
                          featuredTitle: "İndirim / Aylık",
                          featuredData: "%${widget.carElement.monthlyRent}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeaturedCarDetailCard extends StatelessWidget {
  const FeaturedCarDetailCard({
    Key? key,
    required this.height,
    required this.width,
    required this.imageName,
    required this.featuredTitle,
    required this.featuredData,
  }) : super(key: key);

  final double height;
  final double width;
  final String imageName;
  final String featuredTitle;
  final String featuredData;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      child: Container(
        width: width * 0.43,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(
                5.0,
                5.0,
              ),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "assets/svgs/${imageName}.svg",
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      featuredTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      featuredData,
                      style: const TextStyle(
                        fontSize: 10,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarBrandAndBrandModelText extends GetView<CarDetailController> {
  const CarBrandAndBrandModelText({
    super.key,
    required this.widget,
  });

  final CarDetailView widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${widget.carElement.brandName}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 9),
        const Text(
          "-",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          widget.carElement.modelName ?? "",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}

class CarSlider extends GetView<CarDetailController> {
  CarSlider({
    super.key,
    required this.widget,
    required this.current,
  });

  final CarDetailView widget;
  RxInt current = 0.obs;
  final width = Get.width;

  @override
  Widget build(BuildContext context) {
    void _showImagesFullScreenSlider(List<String> imageUrls, int initialIndex) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Stack(
                children: [
                  PhotoViewGallery.builder(
                    itemCount: imageUrls.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(imageUrls[index]),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      );
                    },
                    scrollPhysics: const BouncingScrollPhysics(),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.grey.shade700.withOpacity(0.7),
                    ),
                    pageController: PageController(initialPage: initialIndex),
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
            ),
          );
        },
      );
    }

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.carElement.carAddPhotos!.length,
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: true,
            aspectRatio: 16 / 9,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) => current.value = index,
          ),
          itemBuilder: (context, index, realIdx) {
            return GestureDetector(
              onTap: () => _showImagesFullScreenSlider(controller.carPhotosList, current.value),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (index >= 0 && index < controller.carPhotosList.length)
                      ? Image.network(
                          controller.carPhotosList[index],
                          fit: BoxFit.cover,
                          width: Get.width - 8,
                        )
                      : Image.asset(
                          'assets/logo/logo_dark.png',
                          fit: BoxFit.cover,
                          width: Get.width - 8,
                        ),
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 8,
          right: 12,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.shade200),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.carPhotosList.map(
                (url) {
                  int index = controller.carPhotosList.indexOf(url);
                  return Obx(() => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: current.value == index ? const Color.fromRGBO(0, 0, 0, 0.9) : const Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      ));
                },
              ).toList(),
            ),
          ),
        )
      ],
    );
  }
}

class SeeAvailableLocaitons extends GetView<CarDetailController> {
  const SeeAvailableLocaitons({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        height: Get.height * 0.9,
        width: Get.width * 0.9,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            GoogleMap(
              markers: controller.carAvailableLocationMarkers,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: controller.cameraPosition,
              onMapCreated: (GoogleMapController gmcontroller) {
                if (!controller.googleMapController.isCompleted) {
                  controller.googleMapController.complete(gmcontroller);
                }
              },
              onCameraMove: (cameraPosition) => controller.cameraPosition = cameraPosition,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 8, 0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    CupertinoIcons.xmark_square_fill,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeeAvailableTimes extends GetView<CarDetailController> {
  const SeeAvailableTimes({super.key, required this.widget});

  final CarDetailView widget;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: Get.height * 0.35,
        width: Get.width * 0.7,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(CupertinoIcons.xmark_square_fill, size: 32),
              ),
            ),
            Column(
              children: [
                Column(
                  children: [
                    DeliveryTimeWidget(deliveryTime: widget.carElement.carDeliveryTimes![0]),
                    DeliveryTimeWidget(deliveryTime: widget.carElement.carDeliveryTimes![1]),
                    DeliveryTimeWidget(deliveryTime: widget.carElement.carDeliveryTimes![2]),
                    DeliveryTimeWidget(deliveryTime: widget.carElement.carDeliveryTimes![3]),
                    DeliveryTimeWidget(deliveryTime: widget.carElement.carDeliveryTimes![4]),
                    DeliveryTimeWidget(deliveryTime: widget.carElement.carDeliveryTimes![5]),
                    DeliveryTimeWidget(deliveryTime: widget.carElement.carDeliveryTimes![6]),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryTimeWidget extends StatelessWidget {
  final CarDeliveryTime deliveryTime;

  const DeliveryTimeWidget({Key? key, required this.deliveryTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(deliveryTime.deliveryType, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 16),
        Row(
          children: [
            Text(formatTime(deliveryTime.startTime)),
            const SizedBox(width: 4),
            const Text("-"),
            const SizedBox(width: 4),
            Text(formatTime(deliveryTime.endTime))
          ],
        ),
      ],
    );
  }

  String formatTime(String time) {
    TimeOfDay timeOfDay = TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1]),
    );

    String formattedTime = DateFormat.Hm().format(DateTime(2022, 1, 1, timeOfDay.hour, timeOfDay.minute));
    return formattedTime;
  }
}
