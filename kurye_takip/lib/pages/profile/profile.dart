import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/add_car/test_add.dart';
import 'package:kurye_takip/pages/auth/login.dart';
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
      appBar: AppBar(
        actions: [],
        title: Text("Profil"),
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
                      onPressed: () {},
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          leading: Icon(Icons.info, color: Colors.black54),
                          title: Text('Hakkımızda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54)),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () => Get.to(TestAddCarView()),
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                        leading: Icon(Icons.car_repair_rounded, color: Colors.black54),
                        title: Text('Aracını Kiraya Ver', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          leading: Icon(Icons.privacy_tip_sharp, color: Colors.black54),
                          title: Text('Ayarlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios_outlined)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                        leading: Icon(FontAwesomeIcons.question, color: Colors.black54),
                        title: Text('Sorular/Cevaplar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () => Get.offAll(LoginPage()),
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: const ListTile(
                          leading: Icon(Icons.logout, color: Colors.black54),
                          title: Text('Çıkış Yap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
