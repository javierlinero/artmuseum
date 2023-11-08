import 'package:flutter/material.dart';

Widget buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top:20, left: 10, bottom: 10),
        child: Text(title, style: TextStyle(fontSize: 18,)),
      ),
    );
  }
