// ignore: depend_on_referenced_packages
// ignore_for_file: depend_on_referenced_packages, duplicate_ignore, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:kurye_takip/model/brand.dart';
import 'package:kurye_takip/model/car_add.dart';
import 'package:kurye_takip/model/car_detail.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/model/get_user.dart';
import 'package:kurye_takip/model/model.dart';
import 'package:kurye_takip/model/rent_request_notification.dart';

class ApiService {
  static const String baseUrl = 'https://rentekerapi.takipsa.com';

  //Brand
  static Future<List<BrandElement>> fetchBrands(int carType) async {
    final response = await http.get(Uri.parse("$baseUrl/Brand/GetBrands?car_type=${carType}"));

    if (response.statusCode == 200) {
      return brandFromJson(response.body).brands;
    } else {
      throw Exception("Failed to load data");
    }
  }

  //Model
  static Future<List<ModelElement>> fetchModels(int brandId, int carType) async {
    final response = await http.post(
      Uri.parse("$baseUrl/Model/GetModels?brandId=$brandId&carType=$carType"),
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

  static Future<GeneralResponse> DeleteLocation(location_id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/Car/DeleteLocation?location_id=$location_id"),
    );
    if (response.statusCode == 200) {
      return generalResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<GeneralResponse> CarDerliveryTime(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/Car/AddCarDeliveryTime'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create');
    }
  }

  static Future<Cars> fetchCars() async {
    final response = await http.get(
      Uri.parse("$baseUrl/Car/GetCars"),
    );
    if (response.statusCode == 200) {
      return carsFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Cars> fetchMyCars(user_id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/Car/GetMyCars?user_id=$user_id"),
    );
    if (response.statusCode == 200) {
      return carsFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<GeneralResponse> SendRentRequest(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/Notification/CreateRentRequest'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create');
    }
  }

  static Future<RentRequestNotification> fetchRentNotifications(renter_id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/Notification/GetRentNotifications?renter_id=$renter_id"),
    );
    if (response.statusCode == 200) {
      final result = rentRequestNotificationFromJson(response.body);
      log('Result Type: ${result.runtimeType}');
      return result;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<RentRequestNotification> fetchOwnerNotifications(owner_id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/Notification/GetOwnerNotifications?owner_id=$owner_id"),
    );
    if (response.statusCode == 200) {
      return rentRequestNotificationFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<CarDetail> getCar(car_id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/Car/GetCar?carId=$car_id"),
    );
    if (response.statusCode == 200) {
      return carDetailFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<GeneralResponse> ApproveOrRejectNotification(notification_id, rent_status) async {
    final response = await http.get(
      Uri.parse("$baseUrl/Notification/ApproveOrRejectNotification?rent_status=${rent_status}&notification_id=${notification_id}"),
    );
    if (response.statusCode == 200) {
      return generalResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<GetUser> fetchUser(user_id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/User/GetUser?id=$user_id"),
    );
    if (response.statusCode == 200) {
      return getUserFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<GeneralResponse> editUserInfo(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/Car/CarOwnerInfoEdit'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create');
    }
  }

  static Future<GeneralResponse> editCarInfo(Map body) async {
    final String requestBody = json.encode(body);
    log(requestBody, name: "Edit Body");
    final response = await http.post(
      Uri.parse('$baseUrl/Car/CarInfoEdit'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create');
    }
  }

  static Future<GeneralResponse> editCarAvailableDate(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse("$baseUrl/Car/EditCarAvailableDate"),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<GeneralResponse> EditPhoto(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse("$baseUrl/Car/EditPhoto"),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<GeneralResponse> CarPriceEdit(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse("$baseUrl/Car/CarPriceEdit"),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<GeneralResponse> CarNoteEdit(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse("$baseUrl/Car/CarNoteEdit"),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<GeneralResponse> EditActivity(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse("$baseUrl/Car/ChangeActivity"),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<GeneralResponse> CarRentPhoto(Map body) async {
    final String requestBody = json.encode(body);

    final response = await http.post(
      Uri.parse('$baseUrl/Photo/AddRentPhotos'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create');
    }
  }

  static Future<GeneralResponse> PayPrice(notificationId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/Notification/PayPrice?notification_id=$notificationId"),
    );
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
/*
  static Future<GeneralResponse> GetRentPhotos(photoFrom, rentType) async {
    final response = await http.post(
      Uri.parse("$baseUrl/Photo/PayPrice?notification_id=$notificationId"),
    );
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }*/
}
