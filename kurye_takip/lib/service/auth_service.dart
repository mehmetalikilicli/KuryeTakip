import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kurye_takip/model/login.dart';
import 'package:kurye_takip/model/register.dart';

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

  Future<Login> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Authentication/Login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return Login.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }
}
