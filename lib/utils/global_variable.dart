import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socios/screens/add_post_screen.dart';
import 'package:socios/screens/feed_screen.dart';
import 'package:socios/screens/profile_screen.dart';
import 'package:socios/screens/search_screen.dart';
import 'package:socios/screens/signout.dart';

const webScreedSize = 600;
List<Widget> homescreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
