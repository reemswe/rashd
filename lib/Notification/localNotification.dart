import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../Dashboard/dashboard.dart';
import '../main.dart';

const task = 'firstTask';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();

    // void onNoticationListener(String? payload) async {
    //   if (payload != null && payload.isNotEmpty) {
    //     Navigator.pushReplacement(
    //       GlobalContextService.navigatorKey.currentState!.context,
    //       PageRouteBuilder(
    //         pageBuilder: (context, animation1, animation2) => dashboard(
    //           ID: payload.substring(payload.indexOf('-') + 1),
    //         ),
    //         transitionDuration: const Duration(seconds: 1),
    //         reverseTransitionDuration: Duration.zero,
    //       ),
    //     );
    //   }
    // }

    return Future.value(true);
  });
}

class NotificationService {
  NotificationService();
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  final _localNotifications = FlutterLocalNotificationsPlugin();
  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('1', 'رشد',
            channelDescription: 'رشد',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void selectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      behaviorSubject.add(payload);
    }
  }
}
