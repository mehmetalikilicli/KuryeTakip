// ignore_for_file: deprecated_member_use, non_constant_identifier_names
/*
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/pages/widgets/images.dart';
import 'package:kurye_takip/service/api_service.dart';

class AddRentPhotoController extends GetxController {
  RxList<AddRentImage> carImages = <AddRentImage>[
    AddRentImage(header: "Ön", description: "Aracın önden fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    AddRentImage(header: "Arka", description: "Aracın arkadan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    AddRentImage(header: "Sağ", description: "Aracın sağ yandan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
    AddRentImage(header: "Sol", description: "Aracın sol yandan fotoğrafını yükleyiniz.", ext: "", load: false.obs, photo64: ""),
  ].obs;

  Future<void> pickImageAtIndex(ImageSource source, int index) async {
    final XFile? image = await ImagePicker().pickImage(source: source, imageQuality: 25);
    if (image!.isNull == false) {
      carImages[index].ext = image.path.split(".").last;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: AppImages().cropRatios,
        uiSettings: AppImages().cropSettings,
      );
      if (croppedFile != null) {
        Uint8List bytes = await croppedFile.readAsBytes();
        Uint8List compressedBytes = await FlutterImageCompress.compressWithList(bytes, minHeight: 400, minWidth: 300, quality: 50, rotate: 0);
        if (compressedBytes.length > 2.5 * 1024 * 1024) {
          Helpers.showSnackbar("Uyarı!", "Maksimum fotoğraf boyutunun üzerindedir. Lütfen daha düşük boyutlu fotoğraflar kullanınınz.");
        } else {
          carImages[index].photo64 = base64Encode(compressedBytes);
          carImages[index].load.value = true;
        }
      }
    }
  }

  Future<bool> saveRentCarPhotos(CarElement carElement, int photo_from, int rent_type, rent_id) async {
    GeneralResponse generalResponse = GeneralResponse(success: false, message: "");
    try {
      for (int i = 0; i < carImages.length; i++) {
        Map<String, dynamic> carRentPhotoMap = {
          "rent_id": rent_id,
          "car_id": carElement.carId,
          "base64_image": carImages[i].photo64,
          "ext": carImages[i].ext,
          "photo_type": i + 1,
          "photo_from": photo_from,
          "rent_type": rent_type,
        };
        generalResponse = await ApiService.CarRentPhoto(carRentPhotoMap);
        log(generalResponse.message);
      }
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}

class AddRentImage {
  RxBool load;
  String header;
  String description;
  String photo64;
  String ext;

  AddRentImage({
    required this.description,
    required this.ext,
    required this.header,
    required this.load,
    required this.photo64,
  });
}
*/