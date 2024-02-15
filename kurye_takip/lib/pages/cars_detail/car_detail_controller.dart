// ignore_for_file: non_constant_identifier_names, prefer_collection_literals, division_optimization

import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurye_takip/helpers/get_local_user_id.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/service/api_service.dart';

class CarDetailController extends GetxController {
  CarElement carElement = CarElement();
  Future<void> SendNotification() async {}
  List<String> carPhotosList = [];
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4237, 27.1428), zoom: 14.4746);
  Set<Marker> carAvailableLocationMarkers = Set<Marker>();
  final googleMapController = Completer<GoogleMapController>();
  final carDetailPageKey = GlobalKey<FormState>();

  TextEditingController rentCarDate = TextEditingController();

  DateTime rentCarDateStart = DateTime.now();
  DateTime rentCarDateEnd = DateTime.now();

  TextEditingController note = TextEditingController();

  List<String> FillCarPhotos(CarElement carElement) {
    if (carElement.carAddPhotos!.isNotEmpty) {
      for (var photo in carElement.carAddPhotos!) {
        carPhotosList.add(photo.photoPath);
      }
      return carPhotosList;
    } else {
      return carPhotosList;
    }
  }

  Set<Marker> FillTheMarkers(List<CarAvailableLocation> locations) {
    //cameraPosition =
    //    CameraPosition(target: LatLng(carElement.carAvailableLocations!.first.latitude, carElement.carAvailableLocations!.first.longitude), zoom: 14.4746);

    carAvailableLocationMarkers = locations
        .map((location) => Marker(
              markerId: MarkerId(location.id.toString()),
              position: LatLng(location.latitude, location.longitude),
            ))
        .toSet();
    return carAvailableLocationMarkers;
  }

  Future<GeneralResponse> SendRentRequest(CarElement carElement) async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "Gönderilemedi");
    if (carDetailPageKey.currentState!.validate()) {
      Map<String, dynamic> requestMap = {
        "car_id": carElement.carId,
        "renter_id": getLocalUserID(),
        "owner_id": carElement.userId,
        "rent_status": 0,
        "created_date": DateTime.now().toIso8601String(),
        "renter_note": note.text,
        "cancel_note": "",
        "plate": carElement.plate,
        "rent_start_date": rentCarDateStart.toIso8601String(),
        "rent_end_date": rentCarDateEnd.toIso8601String(),
        "price": calculatePrice(),
        "is_renter_load_before_photo": 0,
        "is_renter_load_after_photo": 0,
        "is_owner_load_before_photo": 0,
        "is_owner_load_after_photo": 0,
        "payment_status": 0,
      };
      generalResponse = await ApiService.SendRentRequest(requestMap);
      log(generalResponse.message, name: "SendRentRequest");
      return generalResponse;
    } else {
      Helpers.showSnackbar("Uyarı!", "Lütfen gerekli alanları doldurunuz.");
      return generalResponse;
    }
  }

  double calculatePrice() {
    Duration difference = rentCarDateEnd.difference(rentCarDateStart);
    int daysDifference = difference.inDays;

    log("Tarih arasındaki gün farkı: $daysDifference gün");

    double totalPrice = 0.0;

    if (daysDifference < 7) {
      totalPrice = (carElement.dailyPrice! * daysDifference);
    } else if (daysDifference >= 7 && daysDifference < 30) {
      totalPrice = (carElement.dailyPrice! * daysDifference * (100 - carElement.weeklyRent!) / 100);
    } else if (daysDifference >= 30) {
      totalPrice = (carElement.dailyPrice! * daysDifference * (100 - carElement.monthlyRent!) / 100);
    }
    return totalPrice;
  }

  double calculateAverageRating() {
    double totalRating = 0.0;
    if (carElement.carComments!.isNotEmpty) {
      for (var comment in carElement.carComments!) {
        totalRating += comment.point;
      }
    }
    if (carElement.carComments!.isNotEmpty) {
      return totalRating / carElement.carComments!.length;
    } else {
      return totalRating;
    }
  }

  Future<bool> isLoggedIn() async {
    final box = GetStorage();
    final userData = box.read('user_data');
    if (userData != null) {
      return true;
    } else {
      return false;
    }
  }
}
