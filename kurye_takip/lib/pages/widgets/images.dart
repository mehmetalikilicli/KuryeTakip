// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class AppImages {
  List<CropAspectRatioPreset> cropRatios = [
    CropAspectRatioPreset.square,
    CropAspectRatioPreset.ratio3x2,
    CropAspectRatioPreset.original,
    CropAspectRatioPreset.ratio4x3,
    CropAspectRatioPreset.ratio16x9,
  ];
  List<PlatformUiSettings> cropSettings = [
    AndroidUiSettings(
      toolbarTitle: 'Fotoğrafı Düzenle',
      toolbarColor: Colors.white,
      toolbarWidgetColor: Colors.black,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: false,
    ),
    IOSUiSettings(title: 'Fotoğrafı Düzenle', cancelButtonTitle: 'Vazgeç', doneButtonTitle: 'Tamam'),
  ];
}
