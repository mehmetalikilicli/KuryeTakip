// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:kurye_takip/model/register.dart';

class ProfileService {
  static const String baseUrl = 'https://rentekerapi.takipsa.com';

  Future<RegisterResponse> editUser(RegisterModel registerData) async {
    final Map<String, dynamic> requestData = {
      "name": registerData.name,
      "surname": registerData.surname,
      "phone": registerData.phone,
      "email": registerData.email,
    };

    final String requestBody = json.encode(requestData);

    final response = await http.post(
      Uri.parse('$baseUrl/User/EditUser'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Güncelleme Başarısız!');
    }
  }
}
