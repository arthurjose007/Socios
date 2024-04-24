import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:socios/models/user.dart';
import 'package:socios/providers/user_provider.dart';
import 'package:socios/resources/firestore_method.dart';
import 'package:socios/utils/colors.dart';
import 'package:socios/widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          "commment",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body:
          //CommentCard(),
          StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy("dataPublished", descending: true)
            .snapshots(),
        builder: (context, snapshort) {
          if (snapshort.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: (snapshort.data! as dynamic).docs.length,
              itemBuilder: (context, Index) => CommentCard(
                    snap: (snapshort.data! as dynamic).docs[Index].data(),
                  ));
        },
      ),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(user!.photoUrl!),
              //widget.snap.data
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Comment as username',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await firestoreMethod().postcomment(
                    widget.snap['postId'],
                    _controller.text.trim(),
                    user!.uid!,
                    user.username!,
                    user.photoUrl!);
                setState(() {
                  _controller.text = "";
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  "Post",
                  style: TextStyle(
                    color: blueColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
