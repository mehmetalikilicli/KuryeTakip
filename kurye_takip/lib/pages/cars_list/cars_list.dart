import 'package:flutter/material.dart';

class CarsList extends StatefulWidget {
  const CarsList({
    super.key,
  });

  @override
  State<CarsList> createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Cars List Page"),
      ),
    );
  }
}
