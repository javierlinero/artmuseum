import 'package:flutter/material.dart';

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
        SizedBox(height: 4), // A little space between the buttons
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
      color: Colors.white, // Button color
      elevation: 2, // Shadow elevation
      borderRadius: BorderRadius.circular(4), // Rounded corners
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4), // Match the border radius
        child: Container(
          width: 48, // Button width
          height: 48, // Button height
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(4), // Again, for the ripple effect
          ),
          child: Icon(
            iconData,
            color: Colors.black, // Icon color
          ),
        ),
      ),
    );
  }
}
