import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/splash_screen.dart';
import 'screens/home_page.dart';
import 'storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await StorageService.init();
  await NotificationService.setup();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        initialRoute: "/",
        routes: {
          "/": (context) => SplashScreen(),
          "/sign_up": (context) => SignUpView(),
          "/login": (context) => LoginView(),
          "/home": (context) => HomePage()
        },
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ));
  }
}

class NotificationService {
  static Future setup() async {
    try {
      //  await FirebaseMessaging.instance.subscribeToTopic('all');
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
      final token = await FirebaseMessaging.instance.getToken();

      log("token is    ${token ?? ""}");
    } catch (e) {
      print(e);
    }
    FirebaseMessaging.onMessage.listen((event) {
      print("There are new notification");
      print(event.data);
    });
  }
}
