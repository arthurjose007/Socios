import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socios/models/post.dart';
import 'package:socios/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class firestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error  occured";
    try {
      String postId = const Uuid().v1();
      String photoUrl =
          await StorageMethod().uploadimageinString("posts", file, true);
      Post post = Post(
          descripton: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImag: profImage,
          likes: []);
      _firestore.collection("post").doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likepost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("post").doc(postid).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection("post").doc(postid).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postcomment(String postid, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection("post")
            .doc(postid)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "name": name,
          "uid": uid,
          "text": text,
          'commentId': commentId,
          "dataPublished": DateTime.now()
        });
      } else {
        print("Text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // deleting post
  Future<void> deletePost(String postId) async {
    print(postId);
    try {
      await _firestore.collection("post").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followid) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("User").doc(uid).get();
      List following = (snap.data()! as dynamic)["following"];
      if (following.contains(followid)) {
        await _firestore.collection("User").doc(followid).update({
          "followers": FieldValue.arrayRemove([uid])
        });
        await _firestore.collection("User").doc(uid).update({
          "following": FieldValue.arrayRemove([followid])
        });
      } else {
        await _firestore.collection("User").doc(followid).update({
          "followers": FieldValue.arrayUnion([uid])
        });
        await _firestore.collection("User").doc(uid).update({
          "following": FieldValue.arrayUnion([followid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
