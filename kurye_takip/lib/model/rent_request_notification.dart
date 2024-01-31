// To parse this JSON data, do
//
//     final rentRequestNotification = rentRequestNotificationFromJson(jsonString);

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

RentRequestNotification rentRequestNotificationFromJson(String str) => RentRequestNotification.fromJson(json.decode(str));

String rentRequestNotificationToJson(RentRequestNotification data) => json.encode(data.toJson());

class RentRequestNotification {
  bool success;
  String message;
  List<RentNotification> notifications;

  RentRequestNotification({
    required this.success,
    required this.message,
    required this.notifications,
  });

  factory RentRequestNotification.fromJson(Map<String, dynamic> json) => RentRequestNotification(
        success: json["success"],
        message: json["message"],
        notifications: List<RentNotification>.from(json["notifications"].map((x) => RentNotification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "notifications": List<dynamic>.from(notifications.map((x) => x.toJson())),
      };
}

class RentNotification {
  int ID;
  int carId;
  int ownerId;
  int renterId;
  int rentStatus;
  String plate;
  DateTime createdDate;
  String? renterNote;
  String? cancelNote;
  String? brandName;
  String? modelName;
  String? ownerName;
  String? ownerSurname;
  String? ownerEmail;
  String? ownerPhone;
  Car? car;

  RentNotification({
    required this.ID,
    required this.carId,
    required this.ownerId,
    required this.renterId,
    required this.rentStatus,
    required this.plate,
    required this.createdDate,
    this.renterNote,
    this.cancelNote,
    this.brandName,
    this.modelName,
    this.ownerName,
    this.ownerSurname,
    this.ownerEmail,
    this.ownerPhone,
    this.car,
  });

  factory RentNotification.fromJson(Map<String, dynamic> json) => RentNotification(
        ID: json["ID"],
        carId: json["car_id"],
        ownerId: json["owner_id"],
        renterId: json["renter_id"],
        rentStatus: json["rent_status"],
        plate: json["plate"],
        createdDate: DateTime.parse(json["created_date"]),
        renterNote: json["renter_note"],
        cancelNote: json["cancel_note"],
        brandName: json["brand_name"],
        modelName: json["model_name"],
        ownerName: json["owner_name"],
        ownerSurname: json["owner_surname"],
        ownerEmail: json["owner_email"],
        ownerPhone: json["owner_phone"],
        car: Car.fromJson(json["car"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "car_id": carId,
        "owner_id": ownerId,
        "renter_id": renterId,
        "rent_status": rentStatus,
        "plate": plate,
        "created_date": createdDate.toIso8601String(),
        "renter_note": renterNote,
        "cancel_note": cancelNote,
        "brand_name": brandName,
        "model_name": modelName,
        "owner_name": ownerName,
        "owner_surname": ownerSurname,
        "owner_email": ownerEmail,
        "owner_phone": ownerPhone,
        "car": car!.toJson(),
      };
}

class Car {
  int id;
  String userName;
  String userSurname;
  String userEmail;
  String userPhone;
  int userId;
  int brandId;
  int? year;
  int modelId;
  String fuelType;
  String transmissionType;
  int carType;
  int dailyPrice;
  String plate;
  String km;
  String note;
  int? weeklyRentDiscount;
  int monthlyRentDiscount;
  int minRentDay;
  int isActive;
  int isApproved;
  int? isLongTerm;
  dynamic isAvailableDateStart;
  dynamic isAvailableDateEnd;

  Car({
    required this.id,
    required this.userName,
    required this.userSurname,
    required this.userEmail,
    required this.userPhone,
    required this.userId,
    required this.brandId,
    required this.year,
    required this.modelId,
    required this.fuelType,
    required this.transmissionType,
    required this.carType,
    required this.dailyPrice,
    required this.plate,
    required this.km,
    required this.note,
    required this.weeklyRentDiscount,
    required this.monthlyRentDiscount,
    required this.minRentDay,
    required this.isActive,
    required this.isApproved,
    required this.isLongTerm,
    required this.isAvailableDateStart,
    required this.isAvailableDateEnd,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json["ID"],
        userName: json["user_name"],
        userSurname: json["user_surname"],
        userEmail: json["user_email"],
        userPhone: json["user_phone"],
        userId: json["user_id"],
        brandId: json["brand_id"],
        year: json["year"],
        modelId: json["model_id"],
        fuelType: json["fuel_type"],
        transmissionType: json["transmission_type"],
        carType: json["car_type"],
        dailyPrice: json["daily_price"],
        plate: json["plate"],
        km: json["km"],
        note: json["note"],
        weeklyRentDiscount: json["weekly_rent_discount"],
        monthlyRentDiscount: json["monthly_rent_discount"],
        minRentDay: json["min_rent_day"],
        isActive: json["is_active"],
        isApproved: json["is_approved"],
        isLongTerm: json["is_long_term"],
        isAvailableDateStart: json["is_available_date_start"],
        isAvailableDateEnd: json["is_available_date_end"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "user_name": userName,
        "user_surname": userSurname,
        "user_email": userEmail,
        "user_phone": userPhone,
        "user_id": userId,
        "brand_id": brandId,
        "year": year,
        "model_id": modelId,
        "fuel_type": fuelType,
        "transmission_type": transmissionType,
        "car_type": carType,
        "daily_price": dailyPrice,
        "plate": plate,
        "km": km,
        "note": note,
        "weekly_rent_discount": weeklyRentDiscount,
        "monthly_rent_discount": monthlyRentDiscount,
        "min_rent_day": minRentDay,
        "is_active": isActive,
        "is_approved": isApproved,
        "is_long_term": isLongTerm,
        "is_available_date_start": isAvailableDateStart,
        "is_available_date_end": isAvailableDateEnd,
      };
}
