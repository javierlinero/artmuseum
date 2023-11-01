import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:puam_app/shared/index.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
              labelText: 'E-Mail Address',
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
              labelText: 'Full Name',
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
              labelText: 'User Name',
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
              labelText: 'New Password',
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
              labelText: 'Confirm Password',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style:
              FilledButton.styleFrom(backgroundColor: AppTheme.princetonOrange),
          child: Text(('Save Changes'), style: AppTheme.signUp),
        ),
      ]),
    );
  }
}
