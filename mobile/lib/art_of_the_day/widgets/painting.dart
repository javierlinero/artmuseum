// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class PaintingWidget extends StatelessWidget {
  final String imageUrl;
  PaintingWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Image.network(
            '$imageUrl/full/full/0/default.jpg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
