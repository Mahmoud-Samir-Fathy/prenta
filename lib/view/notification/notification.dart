import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:printa/shared/components/constants.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? mtoken = '';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    requestPermission();
    initInfo();
    getDeviceToken();
  }

  void initInfo() {
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher'); // Update with your icon resource
    var iosInitialize = const DarwinInitializationSettings();
    var initializeSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null && notificationResponse.payload!.isNotEmpty) {
          // Handle notification payload
        } else {
          // Handle empty payload
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('--------------------onMessage------------------');
      print('onMessage: ${message.notification!.title}/${message.notification!.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformSpecifics = AndroidNotificationDetails(
        '2',
        'asdasdsad',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformSpecifics,
        iOS: const DarwinNotificationDetails(),
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['body'],
      );
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
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
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void getDeviceToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print('My token is $mtoken');
        saveToken(token!);
      });
    }).catchError((error) {
      print('Error getting device token: $error');
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('user device token')
        .add({
      'token': token,
    });
  }


  Future<void> sendPushMessage(String token, String body, String title) async {
    const String projectId = 'prenta-842a9';
    const String url = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
    final String keyFilePath = 'path/to/your-service-account-file.json';

    final accountCredentials = ServiceAccountCredentials.fromJson(
        json.decode(await File(keyFilePath).readAsString()));

    final scopes = [
      'https://www.googleapis.com/auth/firebase.messaging'
    ];

    final authClient = await clientViaServiceAccount(accountCredentials, scopes);

    final Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "click_action": "android.intent.action.MAIN",
          "status": "done",
          "body": body,
          "title": title,
        },
        "android": {
          "notification": {
            "channel_id": "2",
          },
        },
      },
    };

    final response = await authClient.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(
        child: Text('Notification Screen'),
      ),
    );
  }
}
