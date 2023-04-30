import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: const Text("Login")),
        backgroundColor: Colors.white,
        body: ChangeNotifierProvider(
          create: (context) => AuthProvider(),
          builder: (context, child) {
            AuthProvider provider =
                Provider.of<AuthProvider>(context, listen: false);

            return Form(
              key: provider.form,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      color: Theme.of(context).primaryColor,
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 0.28,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 0),
                        child: Column(
                          // physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                            ),
                            Icon(Icons.health_and_safety_rounded,
                                size: 50,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            const SizedBox(height: 30),
                            Card(
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
                                    child: Text("Sign in",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  const SizedBox(height: 30),
                                  TextFormField(
                                    style: const TextStyle(height: 0.2),
                                    decoration: const InputDecoration(
                                        hintText: 'Email'),
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
                                        hintText: 'Password'),
                                    obscureText: true,
                                    controller: provider.passwordController,
                                    validator: (value) {
                                      return (value != null && value.length < 2)
                                          ? 'Too Short'
                                          : null;
                                    },
                                  ),
                                  const RememberButton(),
                                  FractionallySizedBox(
                                      widthFactor: 1,
                                      child: Consumer<AuthProvider>(
                                        builder: (context, value, child) {
                                          return Visibility(
                                            replacement: ElevatedButton(
                                                onPressed: () async {
                                                  provider.onLogin(context);
                                                },
                                                child: const Text("Sign in")),
                                            visible: value.isLoading,
                                            child: const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        },
                                      )),
                                  FractionallySizedBox(
                                      widthFactor: 1,
                                      child: OutlinedButton.icon(
                                          icon: Image.asset(
                                              width: 15,
                                              height: 15,
                                              "assets/Google_Logo.png"),
                                          onPressed: () {},
                                          label: const Text(
                                            "Sign in with Google",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Center(
                                    child: TextButton(
                                        onPressed: () async {
                                          Navigator.pushNamed(
                                              context, "/sign_up");
                                        },
                                        child:
                                            const Text("Do not have account")),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class RememberButton extends StatefulWidget {
  const RememberButton({Key? key}) : super(key: key);

  @override
  State<RememberButton> createState() => _RememberButtonState();
}

class _RememberButtonState extends State<RememberButton> {
  bool checkValue = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checkValue,
          onChanged: (value) {
            setState(() {
              checkValue = (value ?? false);
            });
          },
        ),
        const Text("Remember me "),
      ],
    );
  }
}
