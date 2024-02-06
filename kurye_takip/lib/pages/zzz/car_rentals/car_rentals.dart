// ignore_for_file: prefer_const_constructors
/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/pages/car_rentals/car_rentals_controller.dart';

class CarRentalsPage extends StatefulWidget {
  const CarRentalsPage({super.key});

  @override
  State<CarRentalsPage> createState() => _CarRentalsPageState();
}

final CarRentalController controller = Get.put(CarRentalController());

class _CarRentalsPageState extends State<CarRentalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.fetchData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Hata!"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator(color: Colors.black));
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: const [],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
*/