import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/model/register.dart';

class AuthService {
  static const String baseUrl = 'https://rentekerapi.takipsa.com';

  Future<Register> register(RegisterModel registerData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Authentication/Register'),
      body: {
        "name": registerData.name,
        "phone": registerData.phone,
        "email": registerData.email,
        "password": registerData.password
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      return Register.fromJson(json.decode(response.body));
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
