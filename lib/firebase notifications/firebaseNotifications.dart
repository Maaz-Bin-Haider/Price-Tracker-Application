
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scraper/FCM%20Token%20sender/fcmTokenSender.dart';

class FirebaseNotifications {
  final  _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize Notifications
  Future<void> initNotifications() async {
    InitializationSettings initializationSettings;

    if (Platform.isAndroid) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      initializationSettings = const InitializationSettings(
        android: initializationSettingsAndroid,
      );
    } else if (Platform.isIOS) {
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();

      initializationSettings = const InitializationSettings(
        iOS: initializationSettingsIOS,
      );
    } else if (Platform.isWindows) {
      // Optional Windows-specific initialization (if needed)
      initializationSettings = const InitializationSettings();
      return;
    } else {
      // Unsupported platform
      throw UnsupportedError('This platform is not supported');
    }

    // Initialize Flutter Local Notifications Plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request notification permissions (for iOS)
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Fetch FCM Token
    final fCMToken = await _firebaseMessaging.getToken();
    print(fCMToken.toString());
    
    // This function sends and update FCM token for every user
    fcmTokenSender(fCMToken: fCMToken.toString());


    // Handle background and foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a foreground message: ${message.notification?.title}');
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked! ${message.notification?.title}');
    });

    // On background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler (for when the app is in the background or terminated)
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(); // Initialize Firebase in background if necessary
    print('Handling a background message: ${message.notification?.title}');
    // Process background messages (you can show a notification here if needed)
  }

  // Show local notification when a message is received in the foreground
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'default_channel', // channel id
      'Default Channel', // channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iOSNotificationDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    // Show the notification
    await _flutterLocalNotificationsPlugin.show(
      0, // notification id
      message.notification?.title, // notification title
      message.notification?.body, // notification body
      notificationDetails,
    );
  }
}
