import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socios/models/user.dart' as model;

import 'package:socios/providers/user_provider.dart';
import 'package:socios/resources/firestore_method.dart';
import 'package:socios/utils/colors.dart';
import 'package:socios/utils/imagepicker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isloading = false;
  void postImage(
    String? uid,
    String? username,
    String? profImage,
  ) async {
    setState(() {
      _isloading = true;
    });
    // String userid=uid!;
    // String usernamedata=username!;
    // String profImagedata=profImage!;
    try {
      String res = await firestoreMethod().uploadPost(
          _descriptionController.text, _file!, uid!, username!, profImage!);
      if (res == "success") {
        setState(() {
          _isloading = false;
        });
        showSnackBarhear("Posted!", context);
        clearImage();
      } else {
        setState(() {
          _isloading = false;
        });
        showSnackBarhear(res, context);
      }
    } catch (e) {
      showSnackBarhear(e.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await imagepicker(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Choose form  galery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await imagepicker(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

// void getData() async {
//     UserProvider _userprovider =
//         Provider.of<UserProvider>(context, listen: false);
//     await _userprovider.refreshUser();
//   }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    return
        // user == null
        //     ? Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     :
        _file == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _selectImage(context);
                      },
                      icon: Icon(Icons.upload),
                    ),
                    Text(
                      "Upload Your Post",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    )
                  ],
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  leading: IconButton(
                    onPressed: clearImage,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: const Text(
                    "Post",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // String? userid = user!.uid;
                        // String? username = user!.username;
                        // print(username);
                        // print(userid);
                        postImage(user!.uid, user!.username, user!.photoUrl);
                      },
                      child: Text(
                        "Post",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    _isloading
                        ? LinearProgressIndicator()
                        : Padding(
                            padding: EdgeInsets.only(top: 0),
                          ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            user?.photoUrl == null
                                ? user!.photoUrl!
                                : "https://plus.unsplash.com/premium_photo-1669312747277-b1acd3eb2f98?q=80&w=1297&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            controller: _descriptionController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'write a caption',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 221, 206, 206)),
                              border: InputBorder.none,
                            ),
                            maxLines: 8,
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: MemoryImage(
                                        _file!,
                                      ),
                                      fit: BoxFit.fill,
                                      alignment: FractionalOffset.topCenter)),
                            ),
                          ),
                        ),
                        const Divider()
                      ],
                    )
                  ],
                ),
              );
  }
}
