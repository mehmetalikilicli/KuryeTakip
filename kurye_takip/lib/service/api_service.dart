// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kurye_takip/model/car_item.dart';

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
