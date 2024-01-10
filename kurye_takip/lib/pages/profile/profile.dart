import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/profile_edit_page/profile_edit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (ProfileEditPage())),
              );
            },
          ),
        ],
        title: Text("Profil"),
      ),*/
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: Container(
              height: Get.height * 0.1,
              width: Get.width,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                ProfileInfoContainer(
                  icon: Icons.person,
                  title: "İsim Soyisim",
                  subtitle: "Kullanıcı isim ve soyismi",
                ),
                ProfileInfoContainer(
                  icon: Icons.email,
                  title: "Email",
                  subtitle: "Kullanıcı Email Adresi",
                ),
                /*ProfileInfoContainer(
                  icon: Icons.date_range_outlined,
                  title: "Doğum Tarihi",
                  subtitle: "Kullanıcı Doğum Tarihi",
                ),
                ProfileInfoContainer(
                  icon: Icons.phone,
                  title: "Telefon Numarası",
                  subtitle: "Kullanıcı Telefon Numarası",
                ),*/
                ProfileInfoContainer(
                  icon: Icons.phone,
                  title: "Telefon Numarası",
                  subtitle: "Kullanıcı Telefon Numarası",
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                ProfileInfoContainer(
                  icon: Icons.person,
                  title: "Hakkımızda",
                  subtitle: "Kullanıcı isim ve soyismi",
                ),
                ProfileInfoContainer(
                  icon: Icons.email,
                  title: "Email",
                  subtitle: "Kullanıcı Email Adresi",
                ),
                /*ProfileInfoContainer(
                  icon: Icons.date_range_outlined,
                  title: "Doğum Tarihi",
                  subtitle: "Kullanıcı Doğum Tarihi",
                ),
                ProfileInfoContainer(
                  icon: Icons.phone,
                  title: "Telefon Numarası",
                  subtitle: "Kullanıcı Telefon Numarası",
                ),*/
                ProfileInfoContainer(
                  icon: Icons.phone,
                  title: "Telefon Numarası",
                  subtitle: "Kullanıcı Telefon Numarası",
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                Get.offAll(LoginPage());
              },
              child: Text("Logout")),
        ],
      ),
    );
  }
}

class ProfileInfoContainer extends StatelessWidget {
  ProfileInfoContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  IconData icon = Icons.person;
  String title = "";
  String subtitle = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      height: Get.height * 0.07,
      width: Get.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 2,
                child: Icon(
                  icon,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 16)),
                    Text(subtitle, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8), // Divider'ın üst boşluğu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: Colors.black),
          ), // Divider
        ],
      ),
    );
  }
}
