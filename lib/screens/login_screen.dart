import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socios/resources/auth_methods.dart';
import 'package:socios/responsive/mobileScreen_layout.dart';
import 'package:socios/screens/signup_screen.dart';
import 'package:socios/utils/colors.dart';
import 'package:socios/utils/imagepicker.dart';
import 'package:socios/widgets/text_input_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailcontrollor = TextEditingController();

  final _passwordControlller = TextEditingController();
  bool _isloading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontrollor.dispose();
    _passwordControlller.dispose();
  }

  void signup() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SignUPPage();
    }));
  }

  void loginUser() async {
    setState(() {
      _isloading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await AutMethods().loginUser(
          email: _emailcontrollor.text, password: _passwordControlller.text);
      print("All set go for it");
      print(res);
      if (res == 'success') {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MobileScreenLayout()));
      } else {
        showSnackBarhear(res, context);
      }
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        height: double.infinity,
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              const Text("Socio",
                  style: TextStyle(
                      fontFamily: 'BeauRivage',
                      color: Colors.purpleAccent,
                      fontSize: 65,
                      letterSpacing: .5)),
              const SizedBox(
                height: 15,
              ),
              TextFormFieldMy(
                  textcontrollor: _emailcontrollor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please fill it";
                    } else if (value.isNotEmpty) {
                      String exp = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
                      RegExp regEx = RegExp(exp);
                      String emailId = _emailcontrollor.text;
                      if (!regEx.hasMatch(emailId)) {
                        return "Please enter a valid email id";
                      } else {
                        return null;
                      }
                    }
                    return null;
                  },
                  hinttext: "Enter your email"),
              SizedBox(
                height: 10,
              ),
              TextFormFieldMy(
                  textcontrollor: _passwordControlller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please fill it";
                    } else if (value.isNotEmpty) {
                      String pass =
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                      RegExp passreg = RegExp(pass);
                      String pas = _passwordControlller.text.trim();
                      if (!passreg.hasMatch(pas)) {
                        return 'try a strong password eg:Abc@12';
                      }
                    }
                    return null;
                  },
                  obscuretext: true,
                  hinttext: "Enter your Password"),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  print("ok");
                  loginUser();
                },
                child: Container(
                  child: _isloading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : Text("Login"),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
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
                    margin: const EdgeInsets.all(2),
                    //padding: const EdgeInsets.symmetric(vertical: 2),
                    child: const Text("Eg:email id:"),
                  ),
                  Container(
                    margin: EdgeInsets.all(2),
                    //padding: const EdgeInsets.symmetric(vertical: 2),
                    child: const Text(
                      "arthur2@gmail.com",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(2),
                    //padding: const EdgeInsets.symmetric(vertical: 2),
                    child: const Text("Eg:Password:"),
                  ),
                  Container(
                    margin: EdgeInsets.all(2),
                    //padding: const EdgeInsets.symmetric(vertical: 2),
                    child: const Text(
                      "Arthur@123",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: signup,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
