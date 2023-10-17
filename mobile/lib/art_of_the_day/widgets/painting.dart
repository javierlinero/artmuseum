import 'package:flutter/material.dart';

class PaintingWidget extends StatelessWidget {
  PaintingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          color: Colors.grey,
        ),
      ),
    );
  }
}
