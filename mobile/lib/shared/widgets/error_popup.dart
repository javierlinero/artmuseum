// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ErrorMessagePopup extends StatelessWidget {
  const ErrorMessagePopup({
    super.key,
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade500,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 1,
            offset: Offset(-0.5, -0.5),
          ),
          BoxShadow(
            color: Colors.black,
            blurRadius: 1,
            offset: Offset(0.5, -0.5),
          ),
          BoxShadow(
            color: Colors.black,
            blurRadius: 1,
            offset: Offset(0.5, 0.5),
          ),
          BoxShadow(
            color: Colors.black,
            blurRadius: 1,
            offset: Offset(-0.5, 0.5),
          ),
        ],
      ),
      width: 250,
      height: 50,
      child: Text(
        error,
        style: TextStyle(
            color: Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                  // bottomLeft
                  offset: Offset(-0.5, -0.5),
                  color: Colors.black),
              Shadow(
                  // bottomRight
                  offset: Offset(0.5, -0.5),
                  color: Colors.black),
              Shadow(
                  // topRight
                  offset: Offset(0.5, 0.5),
                  color: Colors.black),
              Shadow(
                  // topLeft
                  offset: Offset(-0.5, 0.5),
                  color: Colors.black),
            ]),
      ),
    );
  }
}
