import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socios/resources/auth_methods.dart';
import 'package:socios/responsive/mobileScreen_layout.dart';
import 'package:socios/responsive/responsive_layout_screen.dart';
import 'package:socios/responsive/webscreen_layout.dart';
import 'package:socios/screens/login_screen.dart';
import 'package:socios/utils/colors.dart';
import 'package:socios/utils/imagepicker.dart';
import 'package:socios/widgets/text_input_field.dart';

class SignUPPage extends StatefulWidget {
  SignUPPage({super.key});

  @override
  State<SignUPPage> createState() => _SignUPPageState();
}

class _SignUPPageState extends State<SignUPPage> {
  final _formKey = GlobalKey<FormState>();

  final emailcontrollor = TextEditingController();

  final passwordControlller = TextEditingController();

  final biocontrollor = TextEditingController();

  final usernameControlller = TextEditingController();
  Uint8List? _image;
  bool _isloading = false;

  @override
  void dispose() {
    emailcontrollor.dispose();
    passwordControlller.dispose();
    biocontrollor.dispose();
    usernameControlller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void navigateToSignup() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
  }

  Future<void> singnUPuser() async {
    if (_image == null) {
      showSnackBarhear("Please select an image to sign up", context);
      return;
    }
    setState(() {
      _isloading = true;
    });
    String res = await AutMethods().signupuser(
      email: emailcontrollor.text,
      password: passwordControlller.text,
      username: usernameControlller.text,
      bio: biocontrollor.text,
      file: _image!,
    );
    print(res);
    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreen: MobileScreenLayout(),
                webScreenLaout: WebScreenLayout(),
              )));
    } else if (res != 'success') {
      showSnackBarhear(res, context);
    }
    setState(() {
      _isloading = false;
    });
    //                   Navigator.of(context).push(MaterialPageRoute(
    //                       builder: (context) => MobileScreenLayout()));
  }

  void isimagepick() async {
    Uint8List img = await imagepicker(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  //blackbox
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // verticalDirection: VerticalDirection.down,
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    Text("Socio",
                        style: TextStyle(
                            fontFamily: 'BeauRivage',
                            color: Colors.purpleAccent,
                            fontSize: 65,
                            letterSpacing: .5)),

                    Flexible(
                      child: SizedBox(
                        height: h * 0.02,
                      ),
                    ),
                    //circular widget to access and show our selected file
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : CircleAvatar(
                                radius: 64,
                                backgroundImage:
                                    AssetImage("assets/images/user.png"),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () {
                              isimagepick();
                            },
                            icon: const Icon(
                              Icons.add_a_photo_rounded,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    Flexible(
                      child: SizedBox(
                        height: h * 0.02,
                      ),
                    ),
                    //textinput for username
                    TextFormFieldMy(
                        textcontrollor: usernameControlller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please fill it";
                          }
                        },
                        hinttext: "Enter your username"),

                    Flexible(
                      child: SizedBox(
                        height: h * 0.02,
                      ),
                    ),
                    //textinput for email
                    TextFormFieldMy(
                        textcontrollor: emailcontrollor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please fill it";
                          } else if (value.isNotEmpty) {
                            String exp =
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
                            RegExp regEx = RegExp(exp);
                            String emailId = emailcontrollor.text;
                            if (!regEx.hasMatch(emailId)) {
                              return "Please enter a valid email id";
                            } else {
                              return null;
                            }
                          }
                          return null;
                        },
                        hinttext: "Enter your email"),
                    Flexible(
                      child: SizedBox(
                        height: h * 0.02,
                      ),
                    ),
                    //textinput for password
                    TextFormFieldMy(
                        textcontrollor: passwordControlller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please fill it";
                          } else if (value.isNotEmpty) {
                            String pass =
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                            RegExp passreg = RegExp(pass);
                            String pas = passwordControlller.text.trim();
                            if (!passreg.hasMatch(pas)) {
                              return 'try a strong password with 8 character eg:Abcd@123';
                            }
                          }
                          return null;
                        },
                        obscuretext: true,
                        hinttext: "Enter the Password"),
                    Flexible(
                      child: SizedBox(
                        height: h * 0.02,
                      ),
                    ),

                    //textinput for username
                    TextFormFieldMy(
                        textcontrollor: biocontrollor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please fill it";
                          }
                        },
                        hinttext: "Emter your Bio"),
                    Flexible(
                      child: SizedBox(
                        height: h * 0.02,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          print("ok");
                          singnUPuser();
                        }
                      },
                      child: Container(
                        child: _isloading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : Text("SignUp"),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),

                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text("I have an account?"),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              onTap: navigateToSignup,
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
