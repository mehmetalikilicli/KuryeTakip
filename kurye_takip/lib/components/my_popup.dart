// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPopup extends StatelessWidget {
  final String title;
  final String message;

  MyPopup({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Diyalogu kapat
          },
          child: Text('Tamam'),
        ),
      ],
    );
  }
}
