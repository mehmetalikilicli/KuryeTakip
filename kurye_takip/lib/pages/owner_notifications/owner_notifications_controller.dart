// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names, avoid_print, unused_local_variable, avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/car_detail.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/model/get_rent_photo.dart';
import 'package:kurye_takip/model/get_user.dart';
import 'package:kurye_takip/model/rent_request_notification.dart';
import 'package:kurye_takip/pages/widgets/images.dart';
import 'package:kurye_takip/service/api_service.dart';

class OwnerNotificationsController extends GetxController {
//General

  RentRequestNotification rentRequestNotification = RentRequestNotification(success: false, message: "", notifications: []);

  RentNotification? selectedNotification;

  RxList<int> notificationApproveList = <int>[].obs;

  String renterName = "";
  String renterSurname = "";
  String renterEmail = "";
  String renterPhone = "";

  int detailIndex = -1;

  RxInt isApproveRent = 0.obs;

  CarElement carElement = CarElement();

  Future<void> getNotificationDetail(int index) async {
    detailIndex = index;
    CarDetail carDetail = await ApiService.getCar(rentRequestNotification.notifications[index].carId);
    carElement = carDetail.car!;

    selectedNotification = rentRequestNotification.notifications[index];
    isOwnerLoadBeforePhoto.value = selectedNotification!.isOwnerLoadBeforePhoto!;
    isOwnerLoadAfterPhoto.value = selectedNotification!.isOwnerLoadAfterPhoto!;
    isRenterLoadBeforePhoto.value = selectedNotification!.isRenterLoadBeforePhoto!;
    isRenterLoadAfterPhoto.value = selectedNotification!.isRenterLoadAfterPhoto!;
  }

  Future<void> fetchOwnerNotifications(int renter_id) async {
    notificationApproveList.clear();
    try {
      rentRequestNotification = await ApiService.fetchOwnerNotifications(renter_id);

      for (int i = 0; i < rentRequestNotification.notifications.length; i++) {
        notificationApproveList.value.add(rentRequestNotification.notifications[i].rentStatus);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> ApproveOrRejectNotification(int rent_status) async {
    try {
      GeneralResponse generalResponse = await ApiService.ApproveOrRejectNotification(rent_status, rentRequestNotification);
      return generalResponse.success;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> fetchRenterUser(int id) async {
    try {
      GetUser renter = await ApiService.fetchUser(id);
      renterName = renter.user.name;
      renterSurname = renter.user.surname;
      renterEmail = renter.user.email;
      renterPhone = renter.user.phone;
    } catch (e) {
      print('Error: $e');
    }
  }

// Add Rent Photo

  int photoFrom = -1;
  int rentType = -1;

  RxInt isOwnerLoadBeforePhoto = (-1).obs;
  RxInt isOwnerLoadAfterPhoto = (-1).obs;
  RxInt isRenterLoadBeforePhoto = (-1).obs;
  RxInt isRenterLoadAfterPhoto = (-1).obs;

  Future<void> getPhotoPage(int photoFrom, int rentType) async {
    this.photoFrom = photoFrom;
    this.rentType = rentType;
    carImages.forEach((image) {
      image.ext = "";
      image.load.value = false;
      image.photo64 = "";
    });
  }

  RxList<RentImage> carImages = <RentImage>[
    RentImage(header: "Aracın önden fotoğrafı", description: "Aracın önden fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    RentImage(header: "Aracın arkadan fotoğrafı", description: "Aracın arkadan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    RentImage(header: "Aracın sağdan fotoğrafı", description: "Aracın sağ yandan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    RentImage(header: "Aracın soldan fotoğrafı", description: "Aracın sol yandan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
  ].obs;

  Future<void> pickImageAtIndex(ImageSource source, int index) async {
    final XFile? image = await ImagePicker().pickImage(source: source, imageQuality: 25);
    if (image!.isNull == false) {
      carImages[index].ext = image.path.split(".").last;
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
          carImages[index].photo64 = base64Encode(compressedBytes);
          carImages[index].load.value = true;
        }
      }
    }
  }

  bool checkLoadImageComplete() {
    for (RentImage item in carImages.value) {
      if (item.load.isFalse) return false;
    }
    return true;
  }

  Future<bool> saveRentCarPhotos(CarElement carElement, int photo_from, int rent_type) async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");
    try {
      if (checkLoadImageComplete()) {
        for (int i = 0; i < carImages.length; i++) {
          Map<String, dynamic> carRentPhotoMap = {
            "rent_id": selectedNotification!.ID,
            "car_id": carElement.carId,
            "base64_image": carImages[i].photo64,
            "ext": carImages[i].ext,
            "photo_type": i + 1,
            "photo_from": photo_from,
            "rent_type": rent_type,
          };
          generalResponse = await ApiService.CarRentPhoto(carRentPhotoMap);
          log(generalResponse.message);
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

  //Comment Renter
  int isRentEnd = 0;
  final commentRenterPageKey = GlobalKey<FormState>();

  TextEditingController comment = TextEditingController();

  double averageRating = 0.0;

  RxDouble rating = (1.0).obs;

  Future<GeneralResponse> GiveRenterComment() async {
    Map<String, dynamic> renterCommentMap = {
      "UserID": selectedNotification!.renterId,
      "CommentedBy": selectedNotification!.ownerId,
      "RentID": selectedNotification?.ID,
      "Comment": comment.text,
      "Point": rating.toInt(),
      "Status": 0,
    };

    GeneralResponse generalResponse = await ApiService.GiveRenterComment(renterCommentMap);
    log(renterCommentMap.toString(), name: "renterCommentMap.toString()");
    return generalResponse;
  }

  double calculateAverageRating() {
    double totalRating = 0.0;
    if (selectedNotification != null) {
      for (var comment in selectedNotification!.renterComment!) {
        totalRating += comment.point;
      }
    }
    if (selectedNotification!.renterComment!.isNotEmpty) {
      return totalRating / selectedNotification!.renterComment!.length;
    } else {
      return totalRating;
    }
  }
}

class RentImage {
  String? path;
  RxBool load;
  String header;
  String description;
  String photo64;
  String ext;
  int? photoFrom;
  int? rentType;
  int? photoType;

  RentImage({
    required this.description,
    required this.ext,
    required this.header,
    required this.load,
    required this.photo64,
    this.path,
    this.photoFrom,
    this.rentType,
    this.photoType,
  });
}
