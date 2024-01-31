// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kurye_takip/model/car_detail.dart';

class OwnerNotificationDetail extends StatelessWidget {
  OwnerNotificationDetail({super.key, required this.carDetail});

  final CarDetail carDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(),
        ),
      ),
    );
  }
}
