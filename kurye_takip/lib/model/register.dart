// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

String registerToJson(RegisterResponse data) => json.encode(data.toJson());

class RegisterResponse {
  bool success;
  String message;
  User user;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
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
  String? name;
  String? surname;
  String? tc;
  DateTime? birth_date;
  String? nationality;
  String? gender;
  String? serial_number;
  String? phone;
  String? email;
  String? password;
  String? city;
  String? district;
  String? address;
  int? is_vehicle_owner;
  String? driving_license_number;
  DateTime? driving_license_date;
  String? driving_license_front_image;
  String? driving_license_front_image_ext;
  String? driving_license_back_image;
  String? driving_license_back_image_ext;

  RegisterModel({
    this.name,
    this.surname,
    this.tc,
    this.birth_date,
    this.gender,
    this.nationality,
    this.serial_number,
    this.phone,
    this.email,
    this.city,
    this.district,
    this.password,
    this.is_vehicle_owner,
    this.address,
    this.driving_license_number,
    this.driving_license_date,
    this.driving_license_front_image,
    this.driving_license_front_image_ext,
    this.driving_license_back_image,
    this.driving_license_back_image_ext,
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
