import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

import '../storage_service.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedPage = 0;

  int get selectedPage => _selectedPage;

  set selectedPage(int page) {
    _selectedPage = page;
    notifyListeners();
  }

  //counter page
  bool loading = false;
  bool walking = false;
  int _count = 0;
  int get count => _count;

  set count(int count) {
    _count = count;
    notifyListeners();
  }

  User? user;

  Future getUser() async {
    String? id = FirebaseAuth.instance.currentUser?.uid;
    if (id != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
        Map<String, dynamic>? data = querySnapshot.data();
        if (data != null) user = User.fromJson(data);
        print(user);
      });
      notifyListeners();
    }
  }

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  void onStepCount(StepCount event) {
    /// Handle step count changed
    count = event.steps;
    saveSteps();
  }

  Future saveSteps() async {
    String? id = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({"score": count});
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    /// Handle status changed
    String status = event.status;
    walking = status == 'walking';
    notifyListeners();
  }

  void onPedestrianStatusError(error) {
    print(error);
  }

  void onStepCountError(error) {
    print(error);
  }

  Future<void> initPlatformState() async {
    /// Init streams
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _stepCountStream = Pedometer.stepCountStream;

    /// Listen to streams and handle errors
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
  }

  //score page
  late Stream<QuerySnapshot<Map<String, dynamic>>> usersStream;
  initStreamUsers() async {
    usersStream = FirebaseFirestore.instance
        .collection("users")
        .orderBy("score", descending: true)
        .snapshots();
  }

  Future<String> getImage(String? id) {
    final ref = FirebaseStorage.instance.ref(id).child('file/');
    return ref.getDownloadURL().then((value) {
      print(value);
      return value;
    });
  }
}
