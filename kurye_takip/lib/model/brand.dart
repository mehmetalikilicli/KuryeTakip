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
        success: json["Success"],
        message: json["Message"],
        brands: List<BrandElement>.from(json["Brands"].map((x) => BrandElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Success": success,
        "Message": message,
        "Brands": List<dynamic>.from(brands.map((x) => x.toJson())),
      };
}

class BrandElement {
  String brandName;
  int brandId;

  BrandElement({
    required this.brandName,
    required this.brandId,
  });

  factory BrandElement.fromJson(Map<String, dynamic> json) => BrandElement(
        brandName: json["BrandName"],
        brandId: json["BrandID"],
      );

  Map<String, dynamic> toJson() => {
        "BrandName": brandName,
        "BrandID": brandId,
      };
}
