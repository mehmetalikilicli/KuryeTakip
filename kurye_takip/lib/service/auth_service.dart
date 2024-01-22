import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/model/register.dart';

class AuthService {
  static const String baseUrl = 'https://rentekerapi.takipsa.com';

  Future<LoginResponse> login(String email, String cyriptedPassword) async {
    final Map<String, dynamic> loginData = {"email": email, "password": cyriptedPassword};

    final String loginBody = json.encode(loginData);

    final response = await http.post(
      Uri.parse("$baseUrl/Authentication/Login"),
      headers: {'Content-Type': 'application/json'},
      body: loginBody,
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<RegisterResponse> register(RegisterModel registerData) async {
    final Map<String, dynamic> requestData = {
      "name": registerData.name,
      "surname": registerData.surname,
      "tc": registerData.tc,
      "birth_date": registerData.birth_date?.toIso8601String() ?? '',
      "gender": registerData.gender,
      "nationality": registerData.nationality,
      "serial_number": registerData.serial_number,
      "phone": registerData.phone,
      "email": registerData.email,
      "city": registerData.city,
      "district": registerData.district,
      "password": registerData.password,
      "is_vehicle_owner": registerData.is_vehicle_owner,
      "address": registerData.address,
      "driving_license_number": registerData.driving_license_number,
      "driving_license_date": registerData.driving_license_date?.toIso8601String() ?? '',
      "driving_license_front": registerData.driving_license_front,
      "driving_license_front_ext": registerData.driving_license_front_ext,
      "driving_license_back": registerData.driving_license_back,
      "driving_license_back_ext": registerData.driving_license_back_ext,
    };

    final String requestBody = json.encode(requestData);

    final response = await http.post(
      Uri.parse('$baseUrl/Authentication/Register'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }
/*
  Future<RegisterResponse> register2(String jsonBody) async {
    final response = await http.post(Uri.parse('$baseUrl/Authentication/Register'), body: {});

    if (response.statusCode == 200) {
      //print(response.body);
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }*/
}
