// ignore_for_file: file_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../Dashboard/dashboard.dart';
import '../main.dart';
import 'localNotification.dart';

class PushNotification {
  final NotificationService notificationService = NotificationService();

  Future initApp() async {
    notificationService.initializePlatformNotifications();
    setupInteractedMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      var Title = message.notification!.title ?? 'no data';
      var Body = message.notification!.body ?? 'no data';

      notificationService.showLocalNotification(
          id: 0, title: Title, body: Body, payload: '${message.data['id']}');
    });
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    Navigator.pushReplacement(
      GlobalContextService.navigatorKey.currentState!.context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => dashboard(
          ID: message.data['id'],
        ),
        transitionDuration: const Duration(seconds: 1),
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
