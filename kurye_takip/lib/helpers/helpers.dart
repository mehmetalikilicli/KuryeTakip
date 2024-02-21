import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/app_constants/logic_constants.dart';

class Helpers {
  static String encryption(String value) {
    final key = encrypt.Key.fromUtf8(LogicConstants.securityKey);
    final iv = encrypt.IV.fromBase64(LogicConstants.securityKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return encrypted.base64;
  }

  static String decryption(String value) {
    final key = encrypt.Key.fromUtf8(LogicConstants.securityKey);
    final iv = encrypt.IV.fromBase64(LogicConstants.securityKey);
    Uint8List bytes = const Base64Decoder().convert(value);
    encrypt.Encrypted encrypted = encrypt.Encrypted(bytes);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  static void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      borderRadius: 16,
      backgroundColor: Colors.white70,
      borderWidth: 1,
      borderColor: AppColors.primaryColor,
    );
  }

  static Future<bool> isLoggedIn() async {
    final box = GetStorage();
    final userData = box.read('user_data');
    if (userData != null) {
      return true;
    } else {
      return false;
    }
  }
}
