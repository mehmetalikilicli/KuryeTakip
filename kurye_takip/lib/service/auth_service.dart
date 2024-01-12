import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/model/register.dart';

class AuthService {
  static const String baseUrl = 'https://rentekerapi.takipsa.com';

  Future<RegisterResponse> register(RegisterModel registerData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Authentication/Register'),
      body: {
        "name": registerData.name,
        "surname": registerData.surname,
        "tc": registerData.tc,
        "birth_date": registerData.birth_date,
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
        "driving_license_date": registerData.driving_license_date,
        "driving_license_front_image": registerData.driving_license_front_image,
        "driving_license_front_image_ext": registerData.driving_license_front_image_ext,
        "driving_license_back_image": registerData.driving_license_back_image,
        "driving_license_back_image_ext": registerData.driving_license_back_image_ext,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<RegisterResponse> register2(String jsonBody) async {
    final response = await http.post(Uri.parse('$baseUrl/Authentication/Register'), body: {});

    if (response.statusCode == 200) {
      //print(response.body);
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Login> login(String email, String cyriptedPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Authentication/Login'),
      body: {
        'email': email,
        'password': cyriptedPassword,
      },
    );

    if (response.statusCode == 200) {
      return Login.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}
