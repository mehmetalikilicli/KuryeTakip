// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool success;
  String message;
  User user;

  LoginResponse({
    required this.success,
    required this.message,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
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
  String? code;
  String? email;
  String? name;
  String? surname;
  String? phone;
  String? city;
  String? district;
  String? address;
  String? tc;
  String? nationality;
  String? gender;
  String? serialNumber;
  //DateTime
  String? birthDate;
  int? isVehicleOwner;
  String? drivingLicenseNumber;
  //DateTime
  String? drivingLicenseDate;
  int? isApproved;
  int? isCommercial;
  int? isDeleted;

  User({
    this.code,
    this.email,
    this.name,
    this.surname,
    this.phone,
    this.city,
    this.district,
    this.address,
    this.tc,
    this.nationality,
    this.gender,
    this.serialNumber,
    this.birthDate,
    this.isVehicleOwner,
    this.drivingLicenseNumber,
    this.drivingLicenseDate,
    this.isApproved,
    this.isCommercial,
    this.isDeleted,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        code: json["code"],
        email: json["email"],
        name: json["name"],
        surname: json["surname"],
        phone: json["phone"],
        city: json["city"],
        district: json["district"],
        address: json["address"],
        tc: json["tc"],
        nationality: json["nationality"],
        gender: json["gender"],
        serialNumber: json["serial_number"],
        birthDate: json["birth_date"],
        isVehicleOwner: json["is_vehicle_owner"],
        drivingLicenseNumber: json["driving_license_number"],
        drivingLicenseDate: json["driving_license_date"],
        isApproved: json["is_approved"],
        isCommercial: json["is_commercial"],
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "email": email,
        "name": name,
        "surname": surname,
        "phone": phone,
        "city": city,
        "district": district,
        "address": address,
        "tc": tc,
        "nationality": nationality,
        "gender": gender,
        "serial_number": serialNumber,
        "birth_date": birthDate,
        "is_vehicle_owner": isVehicleOwner,
        "driving_license_number": drivingLicenseNumber,
        "driving_license_date": drivingLicenseDate,
        "is_approved": isApproved,
        "is_commercial": isCommercial,
        "is_deleted": isDeleted,
      };
}
