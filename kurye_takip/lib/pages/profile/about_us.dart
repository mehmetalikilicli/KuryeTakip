// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/components/texts.dart';
import 'package:kurye_takip/pages/profile/profile_controller.dart';

class AboutUsPage extends StatelessWidget {
  AboutUsPage({super.key});

  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hakkımızda"),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
          shadowColor: Colors.black,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Texts.aboutUstitle1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(Texts.aboutUsContent1),
                ),
              ],
            ),
          ),
        ));
  }
}
