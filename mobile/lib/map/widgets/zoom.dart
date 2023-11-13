// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';

class ZoomButtons extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const ZoomButtons({
    Key? key,
    required this.onZoomIn,
    required this.onZoomOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _ZoomButton(
          iconData: Icons.add,
          onPressed: onZoomIn,
        ),
        SizedBox(height: 4),
        _ZoomButton(
          iconData: Icons.remove,
          onPressed: onZoomOut,
        ),
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const _ZoomButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2, // Shadow elevation
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            iconData,
            color: AppTheme.princetonOrange,
          ),
        ),
      ),
    );
  }
}
