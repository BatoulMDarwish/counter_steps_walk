import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/home_page.dart';
import '../storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  bool isLoading = false;

  void changeSelectedDate(DateTime? dateTime) {
    dateController.text =
        "${dateTime?.day.toString() ?? ""} - ${dateTime?.month.toString() ?? ""} - ${dateTime?.year.toString() ?? ""}";
  }

  Future onSignUp(BuildContext context) async {
    if ((form.currentState?.validate() ?? false)) {
      try {
        print("Start sign up");
        isLoading = true;
        notifyListeners();
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        print("finish sign up");
        if (user.user != null) {
          print("Success sign up");
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          firestore.collection("users").doc(user.user?.uid).set({
            "name": nameController.text,
            "email": emailController.text,
            "age": dateController.text,
            "score": 0
          });
          await StorageService.setUser(
              emailController.text, nameController.text);
          bool result = await uploadFile();

          isLoading = false;
          notifyListeners();
          if (result) {
            emailController.clear();
            passwordController.clear();
            nameController.clear();
            Navigator.pushNamedAndRemoveUntil(
                context, "/home", (route) => false);
          }
        }
      } catch (e) {
        print(e);
        if (e is FirebaseAuthException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message ?? ""),
            ),
          );
        }
        isLoading = false;
        notifyListeners();
      }
    }
  }

  onLogin(BuildContext context) async {
    if (form.currentState?.validate() ?? false) {
      try {
        print("sign in");
        isLoading = true;
        notifyListeners();

        UserCredential resultFirebase = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        print("finish sign in");

        isLoading = false;
        notifyListeners();
        if (resultFirebase.user != null) {
          await StorageService.setUser(
              emailController.text, nameController.text);
          emailController.clear();
          passwordController.clear();
          Navigator.pushReplacementNamed(context, "/home");
        }
      } catch (e) {
        print(e);
        if (e is SocketException) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No connection"),
          ));
        }
        if (e is FirebaseAuthException) {
          if (e.code == "network-request-failed") {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("No connection"),
            ));
          } else
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.message ?? ""),
            ));
          print(e.message);
        }
        isLoading = false;
        notifyListeners();
      }
    }
  }

  FirebaseStorage storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();
  File? photo;

  Future imgFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      photo = File(pickedFile.path);

      notifyListeners();
    } else {
      print('No image selected.');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      photo = File(pickedFile.path);

      notifyListeners();
    } else {
      print('No image selected.');
    }
  }

  Future uploadFile() async {
    if (photo == null) return;
    String? id = FirebaseAuth.instance.currentUser?.uid;

    try {
      final ref = storage.ref(id).child('file/');
      await ref.putFile(photo!);
      return true;
    } catch (e) {
      print('error occured');
      return false;
    }
  }
}
