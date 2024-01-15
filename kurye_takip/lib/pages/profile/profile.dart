import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurye_takip/app_constants/app_colors.dart';
import 'package:kurye_takip/model/register.dart';
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
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.profileFormKey,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  child: Container(
                    height: Get.height * 0.15,
                    width: Get.width,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            controller.changeEditStatus();
                          },
                        ),
                      ),
                      Obx(
                        () => TextFormField(
                          controller: controller.profileName,
                          enabled: controller.isTextEditorsEnabled.value,
                          decoration: const InputDecoration(
                            label: Text("İsim"),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => TextFormField(
                          controller: controller.profileSurname,
                          enabled: controller.isTextEditorsEnabled.value,
                          decoration: const InputDecoration(
                            label: Text("Soyisim"),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                          ),
                          validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => TextFormField(
                          controller: controller.profileEmail,
                          enabled: controller.isTextEditorsEnabled.value,
                          decoration: const InputDecoration(
                            label: Text("Eposta"),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => TextFormField(
                          enabled: controller.isTextEditorsEnabled.value,
                          controller: controller.profilePhone,
                          decoration: const InputDecoration(
                            label: Text("Telefon"),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone, color: AppColors.primaryColor),
                          ),
                          validator: (value) => value!.isEmpty ? "Boş bırakılamaz" : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Obx(
                              () => Visibility(
                                visible: controller.isTextEditorsEnabled.value,
                                child: MaterialButton(
                                  color: AppColors.primaryColor,
                                  child: Text(
                                    "Kaydet",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    controller.registerModel.name = controller.profileName.text;
                                    controller.registerModel.surname = controller.profileSurname.text;
                                    controller.registerModel.email = controller.profileEmail.text;
                                    controller.registerModel.phone = controller.profilePhone.text;

                                    RegisterResponse editProfileResponse = await controller.editUser(controller.registerModel);

                                    //KONTROL
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: MaterialButton(
                    height: 50,
                    minWidth: Get.width * 0.6,
                    color: Colors.red,
                    onPressed: () {
                      Get.offAll(LoginPage());
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
