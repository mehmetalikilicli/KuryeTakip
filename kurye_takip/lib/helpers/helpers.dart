import 'package:encrypt/encrypt.dart';

class Helpers {
  static String encryptPassword(String password) {
    final plainText = password;
    final key = Key.fromUtf8('QeLtGkHhZsXoBuIyUwNpErKlJcMgFqVx');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: 'PKCS7'));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    //print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    //print(encrypted.base64); // R4PxiU3h8YoIRqVowBXm36ZcCeNeZ4s1OvVBTfFlZRdmohQqOpPQqD1YecJeZMAop/hZ4OxqgC1WtwvX/hP9mw==

    return encrypted.base64;
  }
}
