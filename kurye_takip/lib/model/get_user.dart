// To parse this JSON data, do
//
//     final getUser = getUserFromJson(jsonString);

import 'dart:convert';

GetUser getUserFromJson(String str) => GetUser.fromJson(json.decode(str));

String getUserToJson(GetUser data) => json.encode(data.toJson());

class GetUser {
  bool success;
  String message;
  User user;

  GetUser({
    required this.success,
    required this.message,
    required this.user,
  });

  factory GetUser.fromJson(Map<String, dynamic> json) => GetUser(
        success: json["success"],
        message: json["message"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user": user.toJson(),
      };
}

class User {
  int id;
  String name;
  String surname;
  String phone;
  String email;
  String address;
  String city;
  String district;
  String tc;
  String nationality;
  String gender;
  String serialNumber;
  int isVehicleOwner;
  int isCommercial;
  String photoUrl;
  int photoStatus;
  DateTime birthDate;
  String password;
  int isDeleted;
  int isApproved;
  String drivingLicenseNumber;
  DateTime drivingLicenseDate;
  String drivingLicenseFrontImage;
  String drivingLicenseBackImage;
  String notificationToken;
  DateTime createdDate;
  DateTime updatedDate;
  DateTime deletedDate;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.district,
    required this.tc,
    required this.nationality,
    required this.gender,
    required this.serialNumber,
    required this.isVehicleOwner,
    required this.isCommercial,
    required this.photoUrl,
    required this.photoStatus,
    required this.birthDate,
    required this.password,
    required this.isDeleted,
    required this.isApproved,
    required this.drivingLicenseNumber,
    required this.drivingLicenseDate,
    required this.drivingLicenseFrontImage,
    required this.drivingLicenseBackImage,
    required this.notificationToken,
    required this.createdDate,
    required this.updatedDate,
    required this.deletedDate,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["ID"],
        name: json["name"],
        surname: json["surname"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        city: json["city"],
        district: json["district"],
        tc: json["tc"],
        nationality: json["nationality"],
        gender: json["gender"],
        serialNumber: json["serial_number"],
        isVehicleOwner: json["is_vehicle_owner"],
        isCommercial: json["is_commercial"],
        photoUrl: json["photo_url"],
        photoStatus: json["photo_status"],
        birthDate: DateTime.parse(json["birth_date"]),
        password: json["password"],
        isDeleted: json["is_deleted"],
        isApproved: json["is_approved"],
        drivingLicenseNumber: json["driving_license_number"],
        drivingLicenseDate: DateTime.parse(json["driving_license_date"]),
        drivingLicenseFrontImage: json["driving_license_front_image"],
        drivingLicenseBackImage: json["driving_license_back_image"],
        notificationToken: json["notification_token"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
        deletedDate: DateTime.parse(json["deleted_date"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "name": name,
        "surname": surname,
        "phone": phone,
        "email": email,
        "address": address,
        "city": city,
        "district": district,
        "tc": tc,
        "nationality": nationality,
        "gender": gender,
        "serial_number": serialNumber,
        "is_vehicle_owner": isVehicleOwner,
        "is_commercial": isCommercial,
        "photo_url": photoUrl,
        "photo_status": photoStatus,
        "birth_date": birthDate.toIso8601String(),
        "password": password,
        "is_deleted": isDeleted,
        "is_approved": isApproved,
        "driving_license_number": drivingLicenseNumber,
        "driving_license_date": drivingLicenseDate.toIso8601String(),
        "driving_license_front_image": drivingLicenseFrontImage,
        "driving_license_back_image": drivingLicenseBackImage,
        "notification_token": notificationToken,
        "created_date": createdDate.toIso8601String(),
        "updated_date": updatedDate.toIso8601String(),
        "deleted_date": deletedDate.toIso8601String(),
      };
}
