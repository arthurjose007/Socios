import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socios/models/user.dart' as model;

import 'package:socios/providers/user_provider.dart';
import 'package:socios/resources/firestore_method.dart';
import 'package:socios/screens/comment_screen.dart';
import 'package:socios/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:socios/utils/imagepicker.dart';
import 'package:socios/widgets/like_animatiojn.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commmentlen = 0;

  @override
  void initState() {
    super.initState();
    getcomment();
  }

  void getcomment() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("post")
          .doc(widget.snap["postId"])
          .collection("comments")
          .get();
      commmentlen = snap.docs.length;
    } catch (e) {
      showSnackBarhear(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final timestamp = snap['datePublished'];
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return SizedBox();
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: mobileBackgroundColor,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Text(formattedDate),
            Container(
              padding:
                  EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(
                right: 0,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: OutlineInputBorder(),
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: ["Delete"]
                                .map(
                                  (e) => InkWell(
                                    onTap: () async {
                                      firestoreMethod()
                                          .deletePost(widget.snap["postId"]);
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
            // IMAGE SECTION
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: GestureDetector(
                onDoubleTap: () async {
                  await firestoreMethod().likepost(
                      widget.snap['postId'], user!.uid!, widget.snap['likes']);
                  print("working ok");
                  print(user!.uid!);
                  print(widget.snap['likes']);
                  print(widget.snap['postId']);
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      widget.snap['postUrl'],
                      fit: BoxFit.cover,
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 400),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: AnimationLike(
                        child: Icon(
                          Icons.favorite,
                          size: 100,
                          color: Colors.white,
                        ),
                        isAnimationok: isLikeAnimating,
                        duration: Duration(seconds: 600),
                        onend: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                AnimationLike(
                  isAnimationok: widget.snap["likes"].contains(user!.uid),
                  smallliike: true,
                  child: IconButton(
                    onPressed: () async {
                      await firestoreMethod().likepost(widget.snap['postId'],
                          user!.uid!, widget.snap['likes']);
                    },
                    icon: widget.snap["likes"].contains(user!.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                          ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return CommentScreen(
                            snap: widget.snap,
                          );
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.comment_outlined),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ))
              ],
            ),

            //DESCRIPTION AND OF COMMENTS

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.snap["likes"].length} likes",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: primaryColor),
                          children: [
                            TextSpan(
                              text: widget.snap['username'],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "  ${widget.snap['description']}",
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      "View all $commmentlen comments",
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
