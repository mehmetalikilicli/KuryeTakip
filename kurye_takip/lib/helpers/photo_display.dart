import 'dart:convert';

import 'package:flutter/material.dart';

class PhotoDisplayWidget extends StatelessWidget {
  final String base64Image; // Base64 kodlu resim verisi

  const PhotoDisplayWidget({required this.base64Image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotoğraf Görüntüleme'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.memory(
              // Base64 verisini Uint8List'e çevirerek gösterme
              Base64Decoder().convert(base64Image),
              width: 300.0, // İstenilen genişlik
              height: 300.0, // İstenilen yükseklik
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
