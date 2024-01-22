// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kurye_takip/model/brand.dart';
import 'package:kurye_takip/model/car_add.dart';
import 'package:kurye_takip/model/car_item.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/model/model.dart';

class ApiService {
  static const String baseUrl = 'https://rentekerapi.takipsa.com';

  static Future<List<CarItem>> fetchCars() async {
    final response = await http.get(Uri.parse('https://tadilatsepetiapi.takipsa.com/Values/Cars'));

    if (response.statusCode == 200) {
      return carItemFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  //Brand
  static Future<List<BrandElement>> fetchBrands() async {
    final response = await http.get(Uri.parse("$baseUrl/Brand/GetBrands"));

    if (response.statusCode == 200) {
      return brandFromJson(response.body).brands;
    } else {
      throw Exception("Failed to load data");
    }
  }

  //Model
  static Future<List<ModelElement>> fetchModels(int brandId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/Model/GetModels?brandId=$brandId"),
    );

    if (response.statusCode == 200) {
      return modelFromJson(response.body).models;
    } else {
      throw Exception("Failed to load data");
    }
  }

  static Future<CarCreateResponse> CarCreate(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/Car/Create'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return CarCreateResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create');
    }
  }

  static Future<GeneralResponse> CarAddPhoto(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/Car/AddCarPhotos'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create');
    }
  }

  static Future<GeneralResponse> CarAddLocations(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/Car/AddCarLocations'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create');
    }
  }
}
