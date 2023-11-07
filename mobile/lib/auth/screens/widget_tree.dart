import 'package:flutter/material.dart';
import 'package:puam_app/auth/index.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _widgetTreeState();
}

class _widgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LoginPage();
          } else {
            return LoginRegisterPage();
          }
        });
  }
}
