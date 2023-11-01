import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:puam_app/shared/index.dart';
import 'package:settings_ui/settings_ui.dart';


class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SettingsList(
        sections: [
          SettingsSection(
            margin: EdgeInsetsDirectional.all(10),
            title: Text('Account'),
            tiles: [
              SettingsTile(
                title: Text('Settings'),
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: Text('Username'),
                leading: Icon(Icons.person),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: Text('Password'),
                leading: Icon(Icons.password),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),
          SettingsSection(
            margin: EdgeInsetsDirectional.all(10),
            tiles: [
              SettingsTile(
                title: Text('Logout'),
                leading: Icon(Icons.lock),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),
        ],
      ),
       
    );
  }
}