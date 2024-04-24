import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socios/providers/user_provider.dart';
import 'package:socios/utils/global_variable.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLaout;
  final Widget mobileScreen;
  const ResponsiveLayout({
    super.key,
    required this.mobileScreen,
    required this.webScreenLaout,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  void addData() async {
    UserProvider _userprovider =
        Provider.of<UserProvider>(context, listen: false);
    await _userprovider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth > webScreedSize) {
        //web screen
        return widget.webScreenLaout;
      }
      return widget.mobileScreen;
    });
  }
}
