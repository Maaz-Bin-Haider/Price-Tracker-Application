import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scraper/Services/services.dart';
import 'package:scraper/firebase%20notifications/firebaseNotifications.dart';
import 'package:scraper/firebase_options.dart';

import 'Screens/homepage.dart';
import 'windows_notification/windows_notification.dart';


void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Request permission for notifications (especially on desktop)

  await FirebaseNotifications().initNotifications();

  if(Platform.isWindows){
    // Sending notifications when the application opened
    checkAndSendNotifications();
    // sending notificatoins every 10 mins
    Timer.periodic(const Duration(minutes: 10), (timer) {
      checkAndSendNotifications();
      print("Notification function called.");
    });

    // clearing old stored notifications every 1 hour to get latest notifications without missing
    Timer.periodic(const Duration(hours: 1), (timer) {
      sentNotifications.clear();
    });
  }

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Putting Getx Services
  final Services service = Get.put(Services()); 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:  HomePage(),
    );
  }
}

