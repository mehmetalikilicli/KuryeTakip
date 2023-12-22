import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/model/car_item.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CarDetailView extends StatefulWidget {
  const CarDetailView({super.key, required this.car});

  final CarItem car;

  @override
  State<CarDetailView> createState() => _CarDetailViewState();
}

class _CarDetailViewState extends State<CarDetailView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.car.photos.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RxInt current = 0.obs;
    final CarImages = widget.car.photos;

    final height = Get.height - 8;
    final width = Get.width - 8;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("Hemen Kirala"),
        backgroundColor: AppColors.primaryColor,
      ),
      appBar: AppBar(
        title: Text(
          "${widget.car.brand} - ${widget.car.brandModel}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
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
              CarBrandAndBrandModelText(widget: widget),
              const SizedBox(height: 6),
              Text(widget.car.dailyPrice.toString() + "₺" + " / Günlük"),
              const SizedBox(height: 20),
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
                          featuredData: "${widget.car.year}",
                        ),
                        const SizedBox(height: 4),
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "speedometer",
                          featuredTitle: "Kilometre",
                          featuredData: "${widget.car.kilometer}",
                        ),
                        const SizedBox(height: 4),
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "price",
                          featuredTitle: "Ücret / Günlük",
                          featuredData: "${widget.car.dailyPrice} ₺",
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
                          featuredData: "${widget.car.dailyPrice} ₺",
                        ),
                        const SizedBox(height: 4),
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "speedometer",
                          featuredTitle: "Yakıt Tipi",
                          featuredData: "${widget.car.fuelType}",
                        ),
                        const SizedBox(height: 4),
                        FeaturedCarDetailCard(
                          height: height,
                          width: width,
                          imageName: "speedometer",
                          featuredTitle: "Vites",
                          featuredData: "${widget.car.tranmission}",
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
              color: AppColors.primaryColor.withOpacity(0.2),
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
                        fontSize: 14,
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

class CarBrandAndBrandModelText extends StatelessWidget {
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
          "${widget.car.brand}",
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
          widget.car.brandModel,
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

class CarSlider extends StatelessWidget {
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
                    scrollPhysics: BouncingScrollPhysics(),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.grey.shade700.withOpacity(0.7),
                    ),
                    pageController: PageController(initialPage: initialIndex),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
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
          itemCount: widget.car.photos.length,
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: true,
            aspectRatio: 16 / 9,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) => current.value = index,
          ),
          itemBuilder: (context, index, realIdx) {
            return GestureDetector(
              onTap: () => _showImagesFullScreenSlider(widget.car.photos, current.value),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.car.photos[index],
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
              children: widget.car.photos.map(
                (url) {
                  int index = widget.car.photos.indexOf(url);
                  return Obx(() => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: current.value == index
                              ? const Color.fromRGBO(0, 0, 0, 0.9)
                              : const Color.fromRGBO(0, 0, 0, 0.4),
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
