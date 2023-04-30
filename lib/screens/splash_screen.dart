import 'package:flutter/material.dart';

import '../storage_service.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    print("object");
    Future.delayed(
      const Duration(seconds: 2),
      () {
        StorageService.getUser().then((value) {
          if (value != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/home", (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, "/login", (route) => false);
          }
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", width: 120, height: 120),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(width: 70, child: LinearProgressIndicator())
          ],
        ),
      ),
    );
  }
}
