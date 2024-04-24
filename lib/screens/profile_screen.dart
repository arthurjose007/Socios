import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socios/resources/auth_methods.dart';
import 'package:socios/resources/firestore_method.dart';
import 'package:socios/screens/login_screen.dart';
import 'package:socios/utils/colors.dart';
import 'package:socios/utils/imagepicker.dart';
import 'package:socios/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var usersnapshot = await FirebaseFirestore.instance
          .collection("User")
          .doc(widget.uid)
          .get();

      //get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = usersnapshot.data()!;
      followers = usersnapshot.data()!['followers'].length;
      following = usersnapshot.data()!['following'].length;
      isFollowing = usersnapshot
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBarhear(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  )),
              backgroundColor: mobileSearchColor,
              title: Text(
                userData["username"]!,
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Container(
              // color: Colors.blue,
              height: 500,
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                userData['photoUrl'],

                                //"https://images.unsplash.com/photo-1711968558537-21ca3db72a99?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildStatColumn(postLen, "post"),
                                  buildStatColumn(followers, "followers"),
                                  buildStatColumn(following, "following "),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? FollowButton(
                                    backgroundColor: mobileBackgroundColor,
                                    borderColor: Colors.grey,
                                    text: "Sign Out",
                                    textColor: primaryColor,
                                    function: () {
                                      AutMethods().signOut();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) => LoginPage()));
                                    },
                                  )
                                : isFollowing
                                    ? FollowButton(
                                        backgroundColor: Colors.white,
                                        borderColor: Colors.grey,
                                        text: "Unfollow",
                                        textColor: Colors.black,
                                        function: () async {
                                          await firestoreMethod().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              userData["uid"]);
                                          setState(() {
                                            isFollowing = false;
                                            followers--;
                                          });
                                        },
                                      )
                                    : FollowButton(
                                        backgroundColor: Colors.blue,
                                        borderColor: Colors.blue,
                                        text: "follow",
                                        textColor: Colors.white,
                                        function: () async {
                                          await firestoreMethod().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              userData["uid"]);
                                          setState(() {
                                            isFollowing = true;
                                            followers++;
                                          });
                                        },
                                      ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            userData['bio'],
                            //"username",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 1),
                          child: Text(
                            "some description",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("post")
                          .where("uid", isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5),
                            itemBuilder: (context, Index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[Index];
                              return Container(
                                child: Image(
                                  image: NetworkImage(snap["postUrl"]),
                                  fit: BoxFit.cover,
                                ),
                              );
                            });
                      })
                ],
              ),
            ));
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label.toString(),
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
