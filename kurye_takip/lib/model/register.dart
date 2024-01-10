// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Register {
  bool success;
  String message;
  User user;

  Register({
    required this.success,
    required this.message,
    required this.user,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
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

class RegisterModel {
  String name;
  String surname;
  String phone;
  String email;
  String password;
  String? city;
  String? district;
  String? address;
  int is_vehicle_owner;
  String? drivingLicenseNumber;
  String? drivingLicenseDate;
  String? drivingLicenseFrontImage;
  String? drivingLicenseBackImage;

  RegisterModel({
    required this.name,
    required this.surname,
    required this.phone,
    required this.email,
    required this.city,
    required this.district,
    required this.password,
    required this.is_vehicle_owner,
    this.address,
    this.drivingLicenseNumber,
    this.drivingLicenseDate,
    this.drivingLicenseFrontImage,
    this.drivingLicenseBackImage,
  });
}

class User {
  String code;
  String email;
  String name;
  String phone;

  User({
    required this.code,
    required this.email,
    required this.name,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        code: json["code"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "email": email,
        "name": name,
        "phone": phone,
      };
}
