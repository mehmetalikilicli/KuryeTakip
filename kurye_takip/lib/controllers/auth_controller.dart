import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kurye_takip/model/register.dart';
import 'package:kurye_takip/pages/auth/login.dart';
import 'package:kurye_takip/pages/types_page/types_view.dart';
import 'package:kurye_takip/service/api_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  Future<void> register(String email, String password) async {
    try {
      Register result = await _authService.register(email, password);
      Get.to(LoginPage());
    } catch (e) {
      print('Hata: $e');
      Get.snackbar('Hata', 'Kayıt başarısız oldu. Lütfen tekrar deneyin.');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      Register result = await _authService.register(email, password);
      Get.to(TypesPageView());
    } catch (e) {
      print('Hata: $e');
      Get.snackbar('Hata', 'Giriş başarısız oldu. Lütfen tekrar deneyin.');
    }
  }
}
