import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/screens/profile_screen.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              border: UnderlineInputBorder(),
              labelText: 'Username',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              border: UnderlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile()));},
          style:
              FilledButton.styleFrom(backgroundColor: AppTheme.princetonOrange),
          child: Text(('Log In'), style: AppTheme.signUp),
        ),
      ]),
    );
  }
}
