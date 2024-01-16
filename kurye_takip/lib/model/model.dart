// To parse this JSON data, do
//
//     final model = modelFromJson(jsonString);

import 'dart:convert';

Model modelFromJson(String str) => Model.fromJson(json.decode(str));

String modelToJson(Model data) => json.encode(data.toJson());

class Model {
  bool success;
  String message;
  List<ModelElement> models;

  Model({
    required this.success,
    required this.message,
    required this.models,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        success: json["success"],
        message: json["message"],
        models: List<ModelElement>.from(json["models"].map((x) => ModelElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "models": List<dynamic>.from(models.map((x) => x.toJson())),
      };
}

class ModelElement {
  int id;
  int brandId;
  String name;
  String segment;

  ModelElement({
    required this.id,
    required this.brandId,
    required this.name,
    required this.segment,
  });

  factory ModelElement.fromJson(Map<String, dynamic> json) => ModelElement(
        id: json["ID"],
        brandId: json["brand_id"],
        name: json["name"],
        segment: json["segment"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "brand_id": brandId,
        "name": name,
        "segment": segment,
      };
}
