import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:puam_app/shared/index.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:puam_app/user_profile/screens/edit_profile_screen.dart';


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
                onPressed: (BuildContext context) {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()));
                },
              ),
            ],
          ),
          SettingsSection(
            margin: EdgeInsetsDirectional.all(10),
            title: Text('Preferences'),
            tiles: [
              SettingsTile(
                title: Text('Language'),
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: Text('Dark Mode'),
                leading: Icon(Icons.dark_mode),
                onToggle: (value) {},
                initialValue: true,
              ),
              SettingsTile(
                title: Text('Location'),
                leading: Icon(Icons.location_city),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: Text('Notifications'),
                leading: Icon(Icons.notifications),
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