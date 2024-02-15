// ignore_for_file: must_be_immutable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notification extends StatelessWidget {
  Notification({super.key, required this.remoteMessage});

  RemoteMessage remoteMessage = const RemoteMessage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Text("${remoteMessage.notification?.title}"),
            Text("${remoteMessage.notification?.body}"),
            Text("${remoteMessage.data}"),
          ],
        ));
  }
}
