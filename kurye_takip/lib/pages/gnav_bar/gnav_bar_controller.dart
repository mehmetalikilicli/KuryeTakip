import 'package:get/get.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/dashboard/dashboard.dart';
import 'package:kurye_takip/pages/profile/profile.dart';
import 'package:kurye_takip/pages/profile_edit_page/profile_edit.dart';

class BottomNavBarController extends GetxController {
  RxInt index = 0.obs;

  var pages = [Dashboard(), ProfilePage(), LoginPage(), ProfileEditPage()];
}
