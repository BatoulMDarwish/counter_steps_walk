import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setUser(String email, String name) async {
    if (_prefs == null) await init();
    // await _prefs?.setString('email', email);
    // await _prefs?.setString('name', name);

    List<bool> result = await Future.wait(
        [_prefs!.setString("email", email), _prefs!.setString("name", name)]);

    bool resultEmail = result[0];
    bool resultName = result[1];
    if (resultName && resultEmail) return true;
    return false;
  }

  static List<User> getUsers() {
    if (_prefs?.getString("users") != null) {
      return User.decode(_prefs!.getString("users")!);
    }
    return [];
  }

  static Future<String?> getUser() async {
    String? email = _prefs?.getString('email');
    String? name = _prefs?.getString('name');
    if (email != null && name != null) return "Hi $name \nYour email is $email";
    return null;
  }

  static removeUser() async {
    await _prefs?.remove("email");
    await _prefs?.remove("name");
    // await Future.wait(
    //     [prefs.remove('email'), prefs.remove('name')]);
  }
}

class User {
  final String name;
  final String email;
  final String? age;
  final int? score;

  User(
      {this.score, required this.name, required this.email, required this.age});

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
        name: jsonData['name'],
        email: jsonData['email'],
        age: jsonData["age"],
        score: jsonData["score"]);
  }

  static Map<String, dynamic> toJson(User user) => {
        "name": user.name,
        "email": user.email,
        "age": user.age,
        "score": user.score
      };

  static String encode(List<User> users) {
    var list = users
        .map<Map<String, dynamic>>((element) => User.toJson(element))
        .toList();
    return json.encode(list);
  }

  static List<User> decode(String users) {
    final List decodedList = json.decode(users);
    List<User> usersList =
        decodedList.map((element) => User.fromJson(element)).toList();
    return usersList;
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, age: $age}';
  }
}
