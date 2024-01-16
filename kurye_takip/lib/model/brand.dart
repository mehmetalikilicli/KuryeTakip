// To parse this JSON data, do
//
//     final brand = brandFromJson(jsonString);

import 'dart:convert';

Brand brandFromJson(String str) => Brand.fromJson(json.decode(str));

String brandToJson(Brand data) => json.encode(data.toJson());

class Brand {
  bool success;
  String message;
  List<BrandElement> brands;

  Brand({
    required this.success,
    required this.message,
    required this.brands,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        success: json["success"],
        message: json["message"],
        brands: List<BrandElement>.from(json["brands"].map((x) => BrandElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
      };
}

class BrandElement {
  int id;
  String name;

  BrandElement({
    required this.id,
    required this.name,
  });

  factory BrandElement.fromJson(Map<String, dynamic> json) => BrandElement(
        id: json["ID"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "name": name,
      };
}
