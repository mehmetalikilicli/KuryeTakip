import 'package:flutter/material.dart';
import 'package:kurye_takip/pages/notifications/notifications_controller.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationsController controller = NotificationsController();

    return SingleChildScrollView(
      child: Column(
        children: [Text("data")],
      ),
    );
  }
}
