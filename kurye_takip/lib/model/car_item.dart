// To parse this JSON data, do
//
//     final carItem = carItemFromJson(jsonString);

import 'dart:convert';

List<CarItem> carItemFromJson(String str) => List<CarItem>.from(json.decode(str).map((x) => CarItem.fromJson(x)));

String carItemToJson(List<CarItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarItem {
  int type;
  String brand;
  String brandModel;
  String year;
  String kilometer;
  String tranmission;
  String fuelType;
  List<String> photos;
  double dailyPrice;

  CarItem({
    required this.type,
    required this.brand,
    required this.brandModel,
    required this.year,
    required this.kilometer,
    required this.tranmission,
    required this.fuelType,
    required this.photos,
    required this.dailyPrice,
  });

  factory CarItem.fromJson(Map<String, dynamic> json) => CarItem(
        type: json["Type"],
        brand: json["Brand"],
        brandModel: json["BrandModel"],
        year: json["Year"],
        kilometer: json["Kilometer"],
        tranmission: json["Tranmission"]!,
        fuelType: json["FuelType"]!,
        photos: List<String>.from(json["Photos"].map((x) => x)),
        dailyPrice: json["DailyPrice"],
      );

  Map<String, dynamic> toJson() => {
        "Type": type,
        "Brand": brand,
        "BrandModel": brandModel,
        "Year": year,
        "Kilometer": kilometer,
        "Tranmission": tranmission,
        "FuelType": fuelType,
        "Photos": List<dynamic>.from(photos.map((x) => x)),
        "DailyPrice": dailyPrice,
      };
}
