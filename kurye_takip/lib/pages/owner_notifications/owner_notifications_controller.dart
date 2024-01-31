// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names, avoid_print

import 'package:get/get.dart';
import 'package:kurye_takip/model/general_response.dart';
import 'package:kurye_takip/model/rent_request_notification.dart';
import 'package:kurye_takip/service/api_service.dart';

class OwnerNotificationsController extends GetxController {
  RentRequestNotification rentRequestNotification = RentRequestNotification(success: false, message: "", notifications: []);

  RxList<int> notificationApproveList = <int>[].obs;

  Future<void> fetchOwnerNotifications(int renter_id) async {
    notificationApproveList.clear();
    try {
      rentRequestNotification = await ApiService.fetchOwnerNotifications(renter_id);

      for (int i = 0; i < rentRequestNotification.notifications.length; i++) {
        notificationApproveList.value.add(rentRequestNotification.notifications[i].rentStatus);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> ApproveOrRejectNotification(int rent_status) async {
    try {
      GeneralResponse generalResponse = await ApiService.ApproveOrRejectNotification(rent_status, rentRequestNotification);
      return generalResponse.success;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
