import 'package:flutter/material.dart';
import 'package:socios/resources/auth_methods.dart';
import 'package:socios/screens/login_screen.dart';

class signout extends StatelessWidget {
  const signout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ElevatedButton(
            onPressed: () {
              AutMethods().signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text("signout")),
      ),
    );
  }
}
