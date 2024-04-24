import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socios/utils/colors.dart';
import 'package:socios/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileSearchColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text(
          "Socio",
          style: TextStyle(
              color: Colors.blue, fontSize: 32, fontFamily: 'BeauRivage'),
        ),
        actions: [Icon(Icons.messenger_outline_sharp)],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("post").snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshort) {
            if (snapshort.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
                itemCount: snapshort.data!.docs.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    snap: snapshort.data!.docs[index].data(),
                  );
                });
          }),
    );
  }
}
