// To parse this JSON data, do
//
//     final CarCreateResponse = carAddResponseFromJson(jsonString);

import 'dart:convert';

CarCreateResponse carAddResponseFromJson(String str) => CarCreateResponse.fromJson(json.decode(str));

String carAddResponseToJson(CarCreateResponse data) => json.encode(data.toJson());

class CarCreateResponse {
  bool success;
  String message;
  int carId;
  int userId;
  String carPlate;

  CarCreateResponse({
    required this.success,
    required this.message,
    required this.carId,
    required this.userId,
    required this.carPlate,
  });

  factory CarCreateResponse.fromJson(Map<String, dynamic> json) => CarCreateResponse(
        success: json["success"],
        message: json["message"],
        carId: json["car_id"],
        userId: json["user_id"],
        carPlate: json["car_plate"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "car_id": carId,
        "user_id": userId,
        "car_plate": carPlate,
      };
}
