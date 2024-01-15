import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kurye_takip/app_constants/logic_constants.dart';
import 'package:kurye_takip/model/login.dart';

class Helpers {
  static String encryption(String value) {
    final plainText = "72";
    final key = Key.fromUtf8(LogicConstants.securityKey);
    final iv = IV.fromBase64(LogicConstants.securityKey);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print(encrypted.base64);
    return encrypted.base64;
  }

  static String decryption(String value) {
    final key = Key.fromUtf8(LogicConstants.securityKey);
    final iv = IV.fromBase64(LogicConstants.securityKey);
    Uint8List _bytes = const Base64Decoder().convert(value);
    Encrypted encrypted = Encrypted(_bytes);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: 'PKCS7'));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
