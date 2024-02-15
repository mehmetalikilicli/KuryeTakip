// ignore_for_file: prefer_collection_literals, non_constant_identifier_names, avoid_print, invalid_use_of_protected_member, avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/car_detail.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/model/get_rent_photo.dart';
import 'package:kurye_takip/model/get_user.dart';
import 'package:kurye_takip/model/rent_request_notification.dart';
import 'package:kurye_takip/pages/owner_notifications/owner_notifications_controller.dart';
import 'package:kurye_takip/pages/rent_notifications/rent_notification.dart';
import 'package:kurye_takip/pages/widgets/images.dart';
import 'package:kurye_takip/service/api_service.dart';

class RentNotificationsController extends GetxController {
  RentRequestNotification rentRequestNotification = RentRequestNotification(success: false, message: "", notifications: []);

  RentNotification? selectedNotification;
  RxList<int> notificationApproveList = <int>[].obs;

  RxInt rentStatus = (-1).obs;
  RxInt paymnetStatus = (-1).obs;

  String ownerName = "";
  String ownerSurname = "";
  String ownerEmail = "";
  String ownerPhone = "";
  int detailIndex = -1;

  CarElement carElement = CarElement();

  List<String> carPhotosList = [];
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4237, 27.1428), zoom: 14.4746);
  Set<Marker> carAvailableLocationMarkers = Set<Marker>();
  final googleMapController = Completer<GoogleMapController>();

  Future<void> getNotificationDetail(int index) async {
    detailIndex = index;
    CarDetail carDetail = await ApiService.getCar(rentRequestNotification.notifications[index].carId);
    carElement = carDetail.car!;

    selectedNotification = rentRequestNotification.notifications[index];
    isOwnerLoadBeforePhoto.value = selectedNotification!.isOwnerLoadBeforePhoto!;
    isOwnerLoadAfterPhoto.value = selectedNotification!.isOwnerLoadAfterPhoto!;
    isRenterLoadBeforePhoto.value = selectedNotification!.isRenterLoadBeforePhoto!;
    isRenterLoadAfterPhoto.value = selectedNotification!.isRenterLoadAfterPhoto!;

    rentStatus.value = selectedNotification!.rentStatus;
    paymnetStatus.value = selectedNotification!.paymentStatus!;
    Get.to(RenterRequestDetail());
  }

  Future<void> fetchRentNotifications(int renter_id) async {
    notificationApproveList.clear();
    try {
      rentRequestNotification = await ApiService.fetchRentNotifications(renter_id);
      for (int i = 0; i < rentRequestNotification.notifications.length; i++) {
        notificationApproveList.value.add(rentRequestNotification.notifications[i].rentStatus);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<String> FillCarPhotos(CarElement carElement) {
    if (carElement.carAvailableLocations!.isNotEmpty) {
      for (var photo in carElement.carAddPhotos!) {
        carPhotosList.add(photo.photoPath);
      }
      return carPhotosList;
    } else {
      return carPhotosList;
    }
  }

  /*Set<Marker> FillTheMarkers(List<CarAvailableLocation> locations) {
    carAvailableLocationMarkers = locations
        .map((location) => Marker(
              markerId: MarkerId(location.id.toString()),
              position: LatLng(location.latitude, location.longitude),
            ))
        .toSet();
    return carAvailableLocationMarkers;
  }*/

  Future<void> fetchOwnerUser(int id) async {
    try {
      GetUser owner = await ApiService.fetchUser(id);
      ownerName = owner.user.name;
      ownerSurname = owner.user.surname;
      ownerEmail = owner.user.email;
      ownerPhone = owner.user.phone;
    } catch (e) {
      print('Error: $e');
    }
  }

  // Add Rent Photo

  RxInt isOwnerLoadBeforePhoto = (-1).obs;
  RxInt isOwnerLoadAfterPhoto = (-1).obs;
  RxInt isRenterLoadBeforePhoto = (-1).obs;
  RxInt isRenterLoadAfterPhoto = (-1).obs;

  int photoFrom = -1;
  int rentType = -1;

  Future<void> getPhotoPage(int photoFrom, int rentType) async {
    this.photoFrom = photoFrom;
    this.rentType = rentType;
    carAddImages.forEach((image) {
      image.ext = "";
      image.load.value = false;
      image.photo64 = "";
    });

    Get.to(RenterAddRentPhoto());
  }

  RxList<RentImage> carAddImages = <RentImage>[
    RentImage(header: "Aracın önden fotoğrafı", description: "Aracın önden fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    RentImage(header: "Aracın arkadan fotoğrafı", description: "Aracın arkadan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    RentImage(header: "Aracın sağdan fotoğrafı", description: "Aracın sağ yandan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    RentImage(header: "Aracın soldan fotoğrafı", description: "Aracın sol yandan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
  ].obs;

  Future<void> pickImageAtIndex(ImageSource source, int index) async {
    final XFile? image = await ImagePicker().pickImage(source: source, imageQuality: 25);
    if (image!.isNull == false) {
      carAddImages[index].ext = image.path.split(".").last;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: AppImages().cropRatios,
        uiSettings: AppImages().cropSettings,
      );
      if (croppedFile != null) {
        Uint8List bytes = await croppedFile.readAsBytes();
        Uint8List compressedBytes = await FlutterImageCompress.compressWithList(bytes, minHeight: 400, minWidth: 300, quality: 50, rotate: 0);
        if (compressedBytes.length > 2.5 * 1024 * 1024) {
          Helpers.showSnackbar("Uyarı!", "Maksimum fotoğraf boyutunun üzerindedir. Lütfen daha düşük boyutlu fotoğraflar kullanınınz.");
        } else {
          carAddImages[index].photo64 = base64Encode(compressedBytes);
          carAddImages[index].load.value = true;
        }
      }
    }
  }

  bool checkLoadImageComplete() {
    for (RentImage item in carAddImages.value) {
      if (item.load.isFalse) return false;
    }
    return true;
  }

  Future<bool> saveRentCarPhotos(CarElement carElement, int photo_from, int rent_type) async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");
    try {
      if (checkLoadImageComplete()) {
        for (int i = 0; i < carAddImages.length; i++) {
          Map<String, dynamic> carRentPhotoMap = {
            "rent_id": selectedNotification!.ID,
            "car_id": carElement.carId,
            "base64_image": carAddImages[i].photo64,
            "ext": carAddImages[i].ext,
            "photo_type": i + 1,
            "photo_from": photo_from,
            "rent_type": rent_type,
          };
          generalResponse = await ApiService.CarRentPhoto(carRentPhotoMap);
          log(generalResponse.message, name: "saveRentCarPhotos");
        }
        //0 -> from owner, 0 -> before rent
        if (photoFrom == 0 && rent_type == 0) {
          isOwnerLoadBeforePhoto.value = 1;
        } else if (photoFrom == 0 && rent_type == 1) {
          isOwnerLoadAfterPhoto.value = 1;
        } else if (photoFrom == 1 && rent_type == 0) {
          isRenterLoadBeforePhoto.value = 1;
        } else if (photoFrom == 1 && rent_type == 1) {
          isRenterLoadAfterPhoto.value = 1;
        }
        Helpers.showSnackbar("Kaydedildi", "Fotoğraflar kaydedildi");
        Get.back();
        return true;
      } else {
        Helpers.showSnackbar("Uyarı!", "Lütfen gerekli fotoğrafları yükleyiniz.");
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  //Show Photos

  RxList<RentImage> carShowImages = <RentImage>[
    RentImage(
        header: "Aracın önden fotoğrafı",
        description: "Aracın önden fotoğrafını yükleyiniz.",
        ext: "",
        load: false.obs,
        photo64: "",
        path: "",
        photoFrom: -1,
        rentType: -1,
        photoType: 1),
    RentImage(
        header: "Aracın arkadan fotoğrafı",
        description: "Aracın arkadan fotoğrafını yükleyiniz.",
        ext: "",
        load: false.obs,
        photo64: "",
        path: "",
        photoFrom: -1,
        rentType: -1,
        photoType: 2),
    RentImage(
        header: "Aracın sağdan fotoğrafı",
        description: "Aracın sağ yandan fotoğrafını yükleyiniz.",
        ext: "",
        load: false.obs,
        photo64: "",
        path: "",
        photoFrom: -1,
        rentType: -1,
        photoType: 3),
    RentImage(
        header: "Aracın soldan fotoğrafı",
        description: "Aracın sol yandan fotoğrafını yükleyiniz.",
        ext: "",
        load: false.obs,
        photo64: "",
        path: "",
        photoFrom: -1,
        rentType: -1,
        photoType: 4),
  ].obs;

  Future<void> fillPhotos(int photoFrom, int rentType) async {
    Map<String, dynamic> getRentPhotoMap = {
      "car_id": carElement.carId,
      "photo_from": photoFrom,
      "rent_type": rentType,
      "rent_id": selectedNotification!.ID,
    };
    log(getRentPhotoMap.toString(), name: "getRentPhotoMap.toString()");

    GetRentPhoto getRentPhoto = await ApiService.GetRentPhotos(getRentPhotoMap);
    log(getRentPhoto.message, name: "getRentPhoto.message");

    for (int i = 0; i < carShowImages.length; i++) {
      // carShowImages listesindeki her öğe için gerekli eşleşmeyi arayın
      for (int j = 0; j < getRentPhoto.rentPhotoCar.length; j++) {
        // Eğer photoType'lar eşleşiyorsa, atamaları yapın
        if (carShowImages[i].photoType == getRentPhoto.rentPhotoCar[j].photoType) {
          carShowImages[i].photoFrom = getRentPhoto.rentPhotoCar[j].photoFrom;
          carShowImages[i].rentType = getRentPhoto.rentPhotoCar[j].rentType;
          carShowImages[i].path = getRentPhoto.rentPhotoCar[j].photoPath;
          break;
        }
      }
    }
  }

  //Comment Car
  int isRentEnd = 0;
  final commentCarPageKey = GlobalKey<FormState>();

  TextEditingController comment = TextEditingController();

  RxDouble rating = (1.0).obs;

  Future<GeneralResponse> GiveCarComment() async {
    Map<String, dynamic> carCommentMap = {
      "CarID": selectedNotification!.carId,
      "CommentedBy": selectedNotification!.renterId,
      "RentID": selectedNotification?.ID,
      "Comment": comment.text,
      "Point": rating.toInt(),
      "Status": 0,
    };

    GeneralResponse generalResponse = await ApiService.GiveCarComment(carCommentMap);
    log(generalResponse.message, name: "GiveCarComment");
    return generalResponse;
  }
}
