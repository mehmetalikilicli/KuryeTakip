// To parse this JSON data, do
//
//     final carDetail = carDetailFromJson(jsonString);

import 'dart:convert';

import 'package:kurye_takip/model/cars_list.dart';

CarDetail carDetailFromJson(String str) => CarDetail.fromJson(json.decode(str));

String carDetailToJson(CarDetail data) => json.encode(data.toJson());

class CarDetail {
  bool? success;
  String? message;
  CarElement? car;

  CarDetail({
    this.success,
    this.message,
    this.car,
  });

  factory CarDetail.fromJson(Map<String, dynamic> json) => CarDetail(
        success: json["success"],
        message: json["message"],
        car: json["car"] == null ? null : CarElement.fromJson(json["car"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "car": car?.toJson(),
      };
}

class CarAddPhoto {
  int? id;
  int? carId;
  String? photoPath;
  int? photoType;

  CarAddPhoto({
    this.id,
    this.carId,
    this.photoPath,
    this.photoType,
  });

  factory CarAddPhoto.fromJson(Map<String, dynamic> json) => CarAddPhoto(
        id: json["ID"],
        carId: json["car_id"],
        photoPath: json["photo_path"],
        photoType: json["photo_type"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "car_id": carId,
        "photo_path": photoPath,
        "photo_type": photoType,
      };
}

class CarAvailableLocation {
  int? id;
  int? carId;
  String? address;
  String? city;
  String? district;
  double? latitude;
  double? longitude;

  CarAvailableLocation({
    this.id,
    this.carId,
    this.address,
    this.city,
    this.district,
    this.latitude,
    this.longitude,
  });

  factory CarAvailableLocation.fromJson(Map<String, dynamic> json) => CarAvailableLocation(
        id: json["ID"],
        carId: json["car_id"],
        address: json["address"],
        city: json["city"],
        district: json["district"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "car_id": carId,
        "address": address,
        "city": city,
        "district": district,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class CarDeliveryTime {
  int? id;
  String? deliveryType;
  int? carId;
  String? startTime;
  String? endTime;

  CarDeliveryTime({
    this.id,
    this.deliveryType,
    this.carId,
    this.startTime,
    this.endTime,
  });

  factory CarDeliveryTime.fromJson(Map<String, dynamic> json) => CarDeliveryTime(
        id: json["ID"],
        deliveryType: json["delivery_type"],
        carId: json["car_id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "delivery_type": deliveryType,
        "car_id": carId,
        "start_time": startTime,
        "end_time": endTime,
      };
}
