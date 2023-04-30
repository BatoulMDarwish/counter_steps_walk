import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training1/storage_service.dart' hide User;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';
import '../providers/screens/counter_page.dart';
import '../providers/screens/login_page.dart';
import '../providers/screens/scorce_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: false,
      create: (context) {
        var provider = HomeProvider();
        provider.getUser();
        provider.initPlatformState();
        provider.initStreamUsers();
        return provider;
      },
      builder: (context, child) {
        HomeProvider provider = Provider.of(context, listen: false);
        return Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                    onPressed: () async {
                      await StorageService.removeUser();
                      if (mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ));
                      }
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.black54,
                    ))
              ],
              title: Text(
                "Steps counter",
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          bottomNavigationBar: Builder(builder: (context) {
            final selectedPage = context
                .select<HomeProvider, int>((value) => value.selectedPage);
            return BottomNavigationBar(
                currentIndex: selectedPage,
                onTap: (value) {
                  provider.selectedPage = value;
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.directions_walk), label: "My steps"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart), label: "Scores"),
                ]);
          }),
          body: Builder(builder: (context) {
            final selectedPage = context
                .select<HomeProvider, int>((value) => value.selectedPage);
            if (selectedPage == 0) return const CounterPage();
            return const ScoresPage();
          }),
        );
      },
    );
  }
}
