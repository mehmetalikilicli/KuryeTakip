// To parse this JSON data, do
//
//     final getRentPhoto = getRentPhotoFromJson(jsonString);

import 'dart:convert';

GetRentPhoto getRentPhotoFromJson(String str) => GetRentPhoto.fromJson(json.decode(str));

String getRentPhotoToJson(GetRentPhoto data) => json.encode(data.toJson());

class GetRentPhoto {
  bool success;
  String message;
  List<RentPhotoCar> rentPhotoCar;

  GetRentPhoto({
    required this.success,
    required this.message,
    required this.rentPhotoCar,
  });

  factory GetRentPhoto.fromJson(Map<String, dynamic> json) => GetRentPhoto(
        success: json["success"],
        message: json["message"],
        rentPhotoCar: List<RentPhotoCar>.from(json["cars"].map((x) => RentPhotoCar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "cars": List<dynamic>.from(rentPhotoCar.map((x) => x.toJson())),
      };
}

class RentPhotoCar {
  int id;
  int carId;
  int photoFrom;
  String photoPath;
  int photoType;
  int rentType;

  RentPhotoCar({
    required this.id,
    required this.carId,
    required this.photoFrom,
    required this.photoPath,
    required this.photoType,
    required this.rentType,
  });

  factory RentPhotoCar.fromJson(Map<String, dynamic> json) => RentPhotoCar(
        id: json["ID"],
        carId: json["car_id"],
        photoFrom: json["photo_from"],
        photoPath: json["photo_path"],
        photoType: json["photo_type"],
        rentType: json["rent_type"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "car_id": carId,
        "photo_from": photoFrom,
        "photo_path": photoPath,
        "photo_type": photoType,
        "rent_type": rentType,
      };
}
