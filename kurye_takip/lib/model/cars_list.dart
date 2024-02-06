// To parse this JSON data, do
//
//     final cars = carsFromJson(jsonString);

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

Cars carsFromJson(String str) => Cars.fromJson(json.decode(str));

String carsToJson(Cars data) => json.encode(data.toJson());

class Cars {
  bool success;
  String message;
  List<CarElement> cars;

  Cars({
    required this.success,
    required this.message,
    required this.cars,
  });

  factory Cars.fromJson(Map<String, dynamic> json) => Cars(
        success: json["success"],
        message: json["message"],
        cars: List<CarElement>.from(json["cars"].map((x) => CarElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "cars": List<dynamic>.from(cars.map((x) => x.toJson())),
      };
}

class CarElement {
  int? carId;
  int? userId;
  String? userName;
  String? userSurname;
  String? userEmail;
  String? userPhone;
  int? year;
  int? brandId;
  int? modelId;
  String? brandName;
  String? modelName;
  String? fuelType;
  String? transmissionType;
  double? dailyPrice;
  String? plate;
  String? km;
  String? note;
  int? carType;
  int? weeklyRent;
  int? monthlyRent;
  int? minRentDay;
  int? isActive;
  int? isApproved;
  int? isLongTerm;
  int? isCommercial;
  DateTime? is_available_date_start;
  DateTime? is_available_date_end;
  List<CarAddPhoto>? carAddPhotos;
  List<CarAvailableLocation>? carAvailableLocations;
  List<CarDeliveryTime>? carDeliveryTimes;

  CarElement({
    this.carId,
    this.userId,
    this.userName,
    this.userSurname,
    this.userEmail,
    this.userPhone,
    this.year,
    this.brandId,
    this.modelId,
    this.brandName,
    this.modelName,
    this.fuelType,
    this.transmissionType,
    this.dailyPrice,
    this.plate,
    this.km,
    this.note,
    this.weeklyRent,
    this.monthlyRent,
    this.minRentDay,
    this.isActive,
    this.isApproved,
    this.isLongTerm,
    this.isCommercial,
    this.carType,
    this.is_available_date_start,
    this.is_available_date_end,
    this.carAddPhotos,
    this.carAvailableLocations,
    this.carDeliveryTimes,
  });

  factory CarElement.fromJson(Map<String, dynamic> json) => CarElement(
        carId: json["car_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        userSurname: json["user_surname"],
        userEmail: json["user_email"],
        userPhone: json["user_phone"],
        year: json["year"],
        brandId: json["brand_id"],
        modelId: json["model_id"],
        brandName: json["brand_name"],
        modelName: json["model_name"],
        fuelType: json["fuel_type"],
        transmissionType: json["transmission_type"],
        dailyPrice: json["daily_price"],
        plate: json["plate"],
        km: json["km"],
        note: json["note"],
        weeklyRent: json["weekly_rent"],
        monthlyRent: json["monthly_rent"],
        minRentDay: json["min_rent_day"],
        isActive: json["is_active"],
        isApproved: json["is_approved"],
        isLongTerm: json["is_long_term"],
        isCommercial: json["is_commercial"],
        carType: json["car_type"],
        is_available_date_start: json["is_available_date_start"] != null ? DateTime.parse(json["is_available_date_start"]) : null,
        is_available_date_end: json["is_available_date_end"] != null ? DateTime.parse(json["is_available_date_end"]) : null,
        carAddPhotos: List<CarAddPhoto>.from(json["carAddPhotos"].map((x) => CarAddPhoto.fromJson(x))),
        carAvailableLocations: List<CarAvailableLocation>.from(json["carAvailableLocations"].map((x) => CarAvailableLocation.fromJson(x))),
        carDeliveryTimes: List<CarDeliveryTime>.from(json["carDeliveryTimes"].map((x) => CarDeliveryTime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "car_id": carId,
        "user_id": userId,
        "user_name": userName,
        "user_surname": userSurname,
        "user_email": userEmail,
        "user_phone": userPhone,
        "year": year,
        "brand_id": brandId,
        "model_id": modelId,
        "brand_name": brandName,
        "model_name": modelName,
        "fuel_type": fuelType,
        "transmission_type": transmissionType,
        "daily_price": dailyPrice,
        "plate": plate,
        "km": km,
        "note": note,
        "weekly_rent": weeklyRent,
        "monthly_rent": monthlyRent,
        "min_rent_day": minRentDay,
        "is_active": isActive,
        "is_approved": isApproved,
        "is_long_term": isLongTerm,
        "is_commercial": isCommercial,
        "car_type": carType,
        "is_available_date_start": is_available_date_start,
        "is_available_date_end": is_available_date_end,
        "carAddPhotos": List<dynamic>.from(carAddPhotos!.map((x) => x.toJson())),
        "carAvailableLocations": List<dynamic>.from(carAvailableLocations!.map((x) => x.toJson())),
        "carDeliveryTimes": List<dynamic>.from(carDeliveryTimes!.map((x) => x.toJson())),
      };
}

class CarAddPhoto {
  int id;
  int carId;
  String photoPath;
  int photoType;

  CarAddPhoto({
    required this.id,
    required this.carId,
    required this.photoPath,
    required this.photoType,
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
  int id;
  int carId;
  String address;
  String city;
  String district;
  double latitude;
  double longitude;

  CarAvailableLocation({
    required this.id,
    required this.carId,
    required this.address,
    required this.city,
    required this.district,
    required this.latitude,
    required this.longitude,
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
  int id;
  String deliveryType;
  int carId;
  String startTime;
  String endTime;

  CarDeliveryTime({
    required this.id,
    required this.deliveryType,
    required this.carId,
    required this.startTime,
    required this.endTime,
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
