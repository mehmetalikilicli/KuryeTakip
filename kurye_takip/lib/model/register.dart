// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kurye_takip/model/login.dart';

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
  int? is_commercial;
  String? driving_license_number;
  DateTime? driving_license_date;
  String? driving_license_front;
  String? driving_license_front_ext;
  String? driving_license_back;
  String? driving_license_back_ext;

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
    this.is_commercial,
    this.address,
    this.driving_license_number,
    this.driving_license_date,
    this.driving_license_front,
    this.driving_license_front_ext,
    this.driving_license_back,
    this.driving_license_back_ext,
  });
}
