import 'package:flutter/material.dart';
import 'package:socios/models/user.dart';
import 'package:socios/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  //String? data = user.uid;

  final AutMethods _autMethods = AutMethods();
  User? get getUser => _user;
  // User? get getUser {
  //   if (_user != null) {
  //     return _user;
  //   } else {
  //     return null;
  //   }
  // }

  Future<void> refreshUser() async {
    print("calling ok woking");
    User? userdata = await _autMethods.getUserDetails();
    _user = userdata;
    print("data set");
    print(_user!.email);
    // print(userdata.uid);
    // print(userdata.email);
    // print(userdata.username);
    notifyListeners();
  }
}
