// ignore_for_file: prefer_collection_literals, non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/get_user.dart';
import 'package:kurye_takip/model/rent_request_notification.dart';
import 'package:kurye_takip/service/api_service.dart';

class RentNotificationsController extends GetxController {
  RentRequestNotification rentRequestNotification = RentRequestNotification(success: false, message: "", notifications: []);
  String ownerName = "";
  String ownerSurname = "";
  String ownerEmail = "";
  String ownerPhone = "";

  List<String> carPhotosList = [];
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(38.4237, 27.1428), zoom: 14.4746);
  Set<Marker> carAvailableLocationMarkers = Set<Marker>();
  final googleMapController = Completer<GoogleMapController>();

  Future<void> fetchRentNotifications(int renter_id) async {
    try {
      rentRequestNotification = await ApiService.fetchRentNotifications(renter_id);
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

  Set<Marker> FillTheMarkers(List<CarAvailableLocation> locations) {
    carAvailableLocationMarkers = locations
        .map((location) => Marker(
              markerId: MarkerId(location.id.toString()),
              position: LatLng(location.latitude, location.longitude),
            ))
        .toSet();
    return carAvailableLocationMarkers;
  }

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
}
