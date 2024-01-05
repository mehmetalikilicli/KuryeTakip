// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Register {
  bool success;
  String message;
  User user;

  Register({
    required this.success,
    required this.message,
    required this.user,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        success: json["success"],
        message: json["message"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user": user.toJson(),
      };
}

class User {
  String code;
  String email;
  String name;
  String phone;

  User({
    required this.code,
    required this.email,
    required this.name,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        code: json["code"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "email": email,
        "name": name,
        "phone": phone,
      };
}
