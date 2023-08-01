// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationDialog extends StatefulWidget {
  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  void _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', // Replace with your channel ID
      'Channel Name', // Replace with your channel name
      // 'Channel Description', // Replace with your channel description
      importance: Importance.max,
      priority: Priority.high,
    );
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin!.show(
      0,
      'Notification Title',
      'Notification Body',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Notification Permission'),
      content: Text('Do you want to allow notifications?'),
      actions: <Widget>[
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            _showNotification();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
