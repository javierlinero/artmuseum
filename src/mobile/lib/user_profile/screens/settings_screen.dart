import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:puam_app/user_profile/index.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: _buildSettings(context));
  }

  SettingsList _buildSettings(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          margin: EdgeInsetsDirectional.all(10),
          tiles: [
            SettingsTile(
              title: Text('Logout'),
              leading: Icon(Icons.lock),
              onPressed: (BuildContext context) {
                BlocProvider.of<AuthBloc>(context).add(AuthEventSignOut());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
