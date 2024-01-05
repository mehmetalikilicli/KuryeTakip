// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kurye_takip/model/car_item.dart';
import 'package:kurye_takip/model/register.dart';

class CarService {
  static Future<List<CarItem>> fetchCars() async {
    final response = await http.get(Uri.parse('https://tadilatsepetiapi.takipsa.com/Values/Cars'));

    if (response.statusCode == 200) {
      return carItemFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class AuthService {
  static const String baseUrl = 'https://example.com/api';

  Future<Register> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Authentication/Register'),
      body: {
        'email': email,
        'password': password,
        //'name': name,
        //'phone': phone,
      },
    );

    if (response.statusCode == 200) {
      return Register.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Register> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Authentication/Login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return Register.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }
}
