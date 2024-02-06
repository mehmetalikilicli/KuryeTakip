// ignore_for_file: unused_import, unnecessary_import, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/zzz/car_rentals/car_rentals.dart';
import 'package:kurye_takip/pages/my_cars/my_cars.dart';
import 'package:kurye_takip/pages/owner_notifications/owner_notifications.dart';
import 'package:kurye_takip/pages/rent_notifications/rent_notification.dart';
import 'package:kurye_takip/pages/profile/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profil"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircleAvatar(maxRadius: 70, backgroundImage: AssetImage("assets/logo/logo_dark.png"))],
              ),
              const SizedBox(height: 15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(controller.profileName.text, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26))]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(controller.profileEmail.text)]),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Get.to(RentNotificationPage());
                      },
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: Icon(Icons.notifications_active_outlined, color: Colors.black54),
                          title: Text('Taleplerim', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54)),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {
                        Get.to(OwnerNotificationsPage());
                      },
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: Icon(IconData(0xe13c, fontFamily: 'MaterialIcons'), color: Colors.black54),
                          title: Text('Araç Kiralama İstekleri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54)),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () => Get.to(TestAddCarView()),
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Icon(Icons.car_repair_rounded, color: Colors.black54),
                        title: Text('Aracını Kiraya Ver', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {
                        Get.to(MyCarsPage());
                      },
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: Icon(CupertinoIcons.car_detailed, color: Colors.black54),
                          title: Text('Araçlarım', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios_outlined)),
                    ),
                    /*const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {
                        Get.to(CarRentalsPage());
                      },
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: Icon(CupertinoIcons.rectangle_stack_fill, color: Colors.black54),
                          title: Text('Kiralama işlemlerim', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54)),
                    ),*/
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: Icon(CupertinoIcons.profile_circled, color: Colors.black54),
                          title: Text('Profili Düzenle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios_outlined)),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: Icon(CupertinoIcons.settings_solid, color: Colors.black54),
                          title: Text('Ayarlar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios_outlined)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Icon(FontAwesomeIcons.question, color: Colors.black54),
                        title: Text('Sorular/Cevaplar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: Icon(Icons.info_outline, color: Colors.black54),
                          title: Text('Hakkımızda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54)),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () => Get.offAll(LoginPage()),
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: Icon(Icons.logout, color: Colors.black54),
                          title: Text('Çıkış Yap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios_outlined)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
