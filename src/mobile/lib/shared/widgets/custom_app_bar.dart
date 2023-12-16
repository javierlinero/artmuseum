// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puam_app/shared/index.dart';

AppBar appBar(
    {String? helpText, BuildContext? context, GlobalKey? helpButtonKey}) {
  return AppBar(
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    elevation: 0,
    title: SizedBox(
      width: 200,
      child: SvgPicture.asset(
        'assets/logo/puam.svg',
      ),
    ),
    centerTitle: true,
    actions: (helpText != null && context != null)
        ? [
            IconButton(
              key: helpButtonKey,
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text('Help'),
                      content: Text(helpText),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'Close',
                            style: TextStyle(color: AppTheme.princetonOrange),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ]
        : null,
  );
}
