// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'notification_dialog.dart';

class DeviceToken extends StatefulWidget {
  const DeviceToken({Key? key})
      : super(key: key); // Add the missing "Key" parameter

  @override
  State<DeviceToken> createState() => _DeviceTokenState();
}

class _DeviceTokenState extends State<DeviceToken> {
  NotificationServices notificationServices = NotificationServices();

  // Initialize Firebase in the initState method
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print(value);
      }
    });
    notificationServices
        .handleForegroundMessage(); // Call the method to handle foreground messages
  }

  void _showNotificationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => NotificationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Dialog Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showNotificationDialog(context),
          child: Text('Ask for Notification Permission'),
        ),
      ),
    );
  }
}

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("User granted permission: ${settings.authorizationStatus}");
      }
    } else {
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print('device token :$token');

    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  // New method to handle foreground messages
  void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the received message here.
      // You can show a notification or perform other tasks based on the message content.
      if (kDebugMode) {
        print("Foreground message received: ${message.notification?.body}");
      }
    });
  }
}
