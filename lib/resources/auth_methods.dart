import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socios/models/user.dart' as model;
import 'package:socios/resources/storage_method.dart';

class AutMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("User").doc(currentUser.uid).get();
    print("working ok");
    print(snap);
    // Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    // String name = data['username'];
    // String email = data['email'];
    // print('Name: $name, Email: $email');
    // return model.User.fromJson(snap);

    return model.User.fromsnap(snap);
  }

  //sign up user
  Future<String> signupuser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      // if (email.isNotEmpty ||
      //     password.isNotEmpty ||
      //     username.isNotEmpty ||
      //     bio.isNotEmpty ||
      //     file != null) {
      UserCredential crud = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String photurl =
          await StorageMethod().uploadimageinString("profileimg", file, false);

      model.User user = model.User(
        username: username,
        email: email,
        uid: crud.user!.uid,
        photoUrl: photurl,
        bio: bio,
        followers: [],
        following: [],
      );

      _firestore.collection("User").doc(crud.user!.uid).set(user.toJson());

      res = "success";
      //}
    } on FirebaseException catch (err) {
      if (err.code == 'weak-password') {
        res = 'weak-password';
      } else if (err.code == 'invalid-email') {
        print('The email address is invalid.');
        res = 'The email address is invalid.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = "No user found for that email.";
        print("user not found");
      } else if (e.code == 'invalid-credential') {
        res = "Wrong Email or Password";
        print("invalid credential");
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
