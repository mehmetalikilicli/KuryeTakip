// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:developer';
import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

class ImageInfo {
  final String imageData;
  final String imageExtension;

  ImageInfo(this.imageData, this.imageExtension);
}

Future<ImageInfo?> captureAndCompressImage(BuildContext context) async {
  final bool hasPermission = await requestCameraPermission();

  if (hasPermission) {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      final bytes = await image.readAsBytes();
      var result = await FlutterImageCompress.compressWithList(bytes, minWidth: 720, minHeight: 480, quality: 50, rotate: 0);
      final byteLength = result.lengthInBytes;
      final kByte = byteLength / 1024;
      final mByte = kByte / 1024;

      if (mByte > 2.5) {
        log("Maksimum boyut 2.5 MB olabilir.");
        return null;
      } else {
        return ImageInfo(base64.encode(result), image.path.split(".").last);
      }
    } else {
      log("Kullanıcı kamera ile fotoğraf seçmedi.");
      return null;
    }
  } else {
    // Kullanıcı izin vermedi, uyarı göster
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kamera İzni"),
          content: Text("Kamera izni verilmedi. Ayarlara giderek izin verebilirsiniz."),
          actions: [
            TextButton(
              onPressed: () {
                // Ayarlara yönlendirme işlemleri
                // Örneğin:
                // openAppSettings();  // Uygulama ayarlarına yönlendirme için gerekli bir paket
                Navigator.pop(context);
              },
              child: Text("Ayarlar"),
            ),
          ],
        );
      },
    );
    log("Kamera izni verilmedi.");
    return null;
  }
}

Future<bool> requestCameraPermission() async {
  // Kamera izni kontrolü
  PermissionStatus status = await Permission.camera.status;

  if (status.isGranted) {
    return true; // İzin verildiyse true dön
  } else {
    // İzin verilmemişse izin iste
    status = await Permission.camera.request();

    if (status.isGranted) {
      return true; // İzin verildiyse true dön
    } else {
      return false; // İzin verilmediyse false dön
    }
  }
}
