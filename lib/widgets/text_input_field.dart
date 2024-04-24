import 'package:flutter/material.dart';

class TextFormFieldMy extends StatelessWidget {
  TextFormFieldMy(
      {super.key,
      this.obscuretext = false,
      required this.textcontrollor,
      required this.validator,
      required this.hinttext,
      this.textInputType = TextInputType.text});
  final TextEditingController textcontrollor;
  String? Function(String?)? validator;
  final String hinttext;
  final bool obscuretext;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    final InputBorder = OutlineInputBorder(
        // borderRadius:BorderRadius.circular(15),
        borderSide: Divider.createBorderSide(context));
    return TextFormField(
      obscureText: obscuretext,
      controller: textcontrollor,
      validator: validator,
      keyboardType: textInputType,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.white),
        border: InputBorder,
        focusedBorder: InputBorder,
        enabledBorder: InputBorder,
        filled: true,
        fillColor: const Color.fromARGB(255, 4, 39, 233),
        hintText: hinttext,
        hintStyle: TextStyle(color: Colors.white),
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }
}
  // loginuserdata(BuildContext context) async {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       });
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _emailcontrollor.text.trim(),
  //         password: _passwordControlller.text.trim());

  //     Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => MobileScreenLayout(),
  //     ));
  //     //Navigator.of(context).pop();
  //   } on FirebaseAuthException catch (e) {
  //     Navigator.of(context).pop();
  //     print(e.message);
  //     print(e.code);
  //     if (e.code == 'user-not-found') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text(
  //             "No User found for that email",
  //             style: TextStyle(fontSize: 17),
  //           ),
  //         ),
  //       );
  //     } else if (e.code == 'wrong-password') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text(
  //           "Wrong-password",
  //           style: TextStyle(fontSize: 17),
  //         )),
  //       );
  //     } else if (e.code == 'invalid-credential') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             //shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
  //             behavior: SnackBarBehavior.floating,
  //             content: Text(
  //               "email and password not matching please try forgotPassword",
  //               style: TextStyle(fontSize: 17),
  //             )),
  //       );
  //     }
  //   }
  // }