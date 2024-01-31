// ignore_for_file: non_constant_identifier_names, prefer_collection_literals

import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurye_takip/helpers/get_local_user_id.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/service/api_service.dart';

class CarDetailController extends GetxController {
  Future<void> SendNotification() async {}
  List<String> carPhotosList = [];
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4237, 27.1428), zoom: 14.4746);
  Set<Marker> carAvailableLocationMarkers = Set<Marker>();
  final googleMapController = Completer<GoogleMapController>();

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

  Set<Marker> FillTheMarkers(List<CarAvailableLocation> locations) {
    carAvailableLocationMarkers = locations
        .map((location) => Marker(
              markerId: MarkerId(location.id.toString()),
              position: LatLng(location.latitude, location.longitude),
            ))
        .toSet();
    return carAvailableLocationMarkers;
  }

  Future<bool> SendRentRequest(CarElement carElement) async {
    Map<String, dynamic> requestMap = {
      "car_id": carElement.carId,
      "renter_id": getLocalUserID(),
      "owner_id": carElement.userId,
      "rent_status": 0,
      "created_date": DateTime.now().toIso8601String(),
      "renter_note": "",
      "cancel_note": "",
    };
    GeneralResponse generalResponse = await ApiService.SendRentRequest(requestMap);
    return generalResponse.success;
  }
}
