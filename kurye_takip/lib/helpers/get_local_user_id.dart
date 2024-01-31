import 'package:get_storage/get_storage.dart';
import 'package:kurye_takip/helpers/helpers.dart';
import 'package:kurye_takip/model/login.dart';

int getLocalUserID() {
  final box = GetStorage();
  final userData = box.read('user_data');
  if (userData != null) {
    var user = User.fromJson(userData);
    int userID = int.parse(Helpers.decryption(user.code!));
    return userID;
  } else {
    return 0;
  }
}
