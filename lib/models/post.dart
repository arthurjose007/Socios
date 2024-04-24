import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String descripton;
  final String username;
  final String uid;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImag;
  final likes;

  Post(
      {required this.descripton,
      required this.uid,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profileImag,
      required this.likes});
  Map<String, dynamic> toJson() => {
        "description": descripton,
        "username": username,
        "uid": uid,
        "postId": postId,
        "datePublished": datePublished,
        "profImage": profileImag,
        "likes": likes,
        "postUrl": postUrl,
      };

  static Post fromsnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot["username"],
      descripton: snapshot["description"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datepublished"],
      profileImag: snapshot["profImage"],
      likes: snapshot["likes"],
      postUrl: snapshot["postUrl"],
    );
  }
}
