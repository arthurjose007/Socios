import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:socios/models/user.dart' as model;
import 'package:socios/providers/user_provider.dart';
import 'package:socios/utils/colors.dart';
import 'package:socios/utils/global_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _selecteditem = 0;
  late PageController pagecon;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pagecon = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pagecon.dispose();
  }

  void navigationTapped(int page) {
    pagecon.jumpToPage(page);
  }

  void onpagechages(int page) {
    setState(() {
      _selecteditem = page;
    });
  }
  // String username = "";
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getUsername();
  // }

  // void getUsername() async {
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //       .collection('User')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   print(documentSnapshot.data());
  //   setState(() {
  //     username = (documentSnapshot.data() as Map<String, dynamic>)['username'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // model.User? user = Provider.of<UserProvider>(context).getUser;
    //user.username

    return Scaffold(
      body: SafeArea(
          child: PageView(
        children: homescreenItems,
        physics: NeverScrollableScrollPhysics(),
        controller: pagecon,
        onPageChanged: onpagechages,
      )),
      bottomNavigationBar: BottomNavigationBar(
          onTap: navigationTapped,
          currentIndex: _selecteditem,
          selectedItemColor: primaryColor,
          //unselectedItemColor: secondaryColor,
          backgroundColor: Colors.blue,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _selecteditem == 0 ? primaryColor : secondaryColor,
                ),
                label: "",
                backgroundColor: mobileBackgroundColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: _selecteditem == 1 ? primaryColor : secondaryColor,
                ),
                label: "",
                backgroundColor: mobileBackgroundColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  color: _selecteditem == 2 ? primaryColor : secondaryColor,
                ),
                label: "",
                backgroundColor: mobileBackgroundColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: _selecteditem == 3 ? primaryColor : secondaryColor,
                ),
                label: "",
                backgroundColor: mobileBackgroundColor),
          ]),
    );
  }
}
