import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home_page.dart';
import 'image_upload.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ChangeNotifierProvider(
          create: (context) => AuthProvider(),
          builder: (context, child) {
            AuthProvider provider =
                Provider.of<AuthProvider>(context, listen: false);

            return Form(
              key: provider.form,
              autovalidateMode: AutovalidateMode.disabled,
              child: Stack(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: BackButton()),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Icon(Icons.health_and_safety_rounded,
                                size: 50,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                elevation: 20,
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  children: [
                                    const Center(
                                      child: Text("Sign up",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(height: 30),
                                    const ImageUpload(),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      style: const TextStyle(height: 0.2),
                                      decoration: const InputDecoration(
                                          labelText: 'Email'),
                                      controller: provider.emailController,
                                      validator: (value) {
                                        return (value != null &&
                                                !value.contains('@'))
                                            ? 'Use the @ char.'
                                            : null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      style: const TextStyle(height: 0.2),
                                      decoration: const InputDecoration(
                                          hintText: 'Name'),
                                      controller: provider.nameController,
                                      validator: (value) {},
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      style: const TextStyle(height: 0.2),
                                      decoration: const InputDecoration(
                                          hintText: 'Birthday'),
                                      controller: provider.dateController,
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? result = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              selectedDate ?? DateTime.now(),
                                          firstDate: DateTime(2018),
                                          lastDate: DateTime(2024),
                                        );
                                        selectedDate = result;
                                        provider.changeSelectedDate(result);
                                      },
                                      validator: (value) {},
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      style: const TextStyle(height: 0.2),
                                      decoration: const InputDecoration(
                                          hintText: 'Password'),
                                      obscureText: true,
                                      controller: provider.passwordController,
                                      validator: (value) {
                                        return (value != null &&
                                                value.length < 2)
                                            ? 'Too Short'
                                            : null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    FractionallySizedBox(
                                        widthFactor: 1,
                                        child: Consumer<AuthProvider>(
                                          builder: (context, value, child) {
                                            return Visibility(
                                              replacement: ElevatedButton(
                                                  onPressed: () async {
                                                    provider.onSignUp(context);
                                                  },
                                                  child: const Text("Sign up")),
                                              visible: value.isLoading,
                                              child: const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            );
                                          },
                                        )),
                                    Center(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Have account")),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}

class BirthdayField extends StatefulWidget {
  const BirthdayField({Key? key}) : super(key: key);

  @override
  State<BirthdayField> createState() => _BirthdayFieldState();
}

class _BirthdayFieldState extends State<BirthdayField> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    AuthProvider provider = Provider.of(context, listen: false);
    return TextFormField(
      style: const TextStyle(height: 0.2),
      decoration: const InputDecoration(hintText: 'Birthday'),
      controller: provider.nameController,
      readOnly: true,
      onTap: () async {
        DateTime? result = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime(2015),
          firstDate: DateTime(1888),
          lastDate: DateTime(2020),
        );
        print(result);
        selectedDate = result;
        provider.dateController.text = result?.toIso8601String() ?? "";
        print(provider.dateController.text);
        setState(() {});
      },
      validator: (value) {},
    );
  }
}
