import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? username;
  String? email;
  String? uid;
  String? photoUrl;
  String? bio;
  List<dynamic>? followers;
  List<dynamic>? following;

  User(
      {this.username,
      this.email,
      this.uid,
      this.photoUrl,
      this.bio,
      this.followers,
      this.following});
  // User.fromJson(Map<String, dynamic> json) {
  //   email = json['email'];
  //   username = json['username'];
  //   uid = json['uid'];
  //   bio = json['bio'];
  //   photoUrl = json['photoUrl'];
  //   followers = json['followers'];
  //   following = json['following'];
  // }
  // Map<String, dynamic> toJson() => {
  //       "username": username,
  //       "uid": uid,
  //       "email": email,
  //       "photoUrl": photoUrl,
  //       "bio": bio,
  //       "followers": followers,
  //       "following": following
  //     };
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['uid'] = uid;
    data['bio'] = bio;
    data['photoUrl'] = photoUrl;
    data['followers'] = followers;
    data['following'] = following;
    return data;
  }

  static User fromsnap(DocumentSnapshot snap) {
    //var
    Map<String, dynamic>? snapshot = snap.data() as Map<String, dynamic>;

    return User(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        photoUrl: snapshot["photoUrl"],
        bio: snapshot["bio"],
        followers: snapshot["followers"],
        following: snapshot["following"]);
  }
  // static User? fromsnap(DocumentSnapshot snap) {
  //   try {
  //     final Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;
  //     return User(
  //       username: snapshot["username"] as String,
  //       uid: snapshot["uid"] as String,
  //       email: snapshot["email"] as String,
  //       photoUrl: snapshot["photoUrl"] as String,
  //       bio: snapshot["bio"] as String,
  //       followers:
  //           snapshot["followers"] != null ? snapshot["followers"] as List : [],
  //       following:
  //           snapshot["following"] != null ? snapshot["following"] as List : [],
  //     );
  //   } catch (e) {
  //     print("Error creating User from snapshot: $e");
  //     // Optionally re-throw the error or return a default User object
  //   }
  // }
}
