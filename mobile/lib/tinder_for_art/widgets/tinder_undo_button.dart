// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/tinder_for_art/index.dart';

class TinderUndoButton extends StatelessWidget {
  const TinderUndoButton({
    super.key,
    required this.appinioController,
    required this.state,
  });

  final AppinioController appinioController;
  final ArtworkState state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        state.canUndo ? appinioController.undoSwipe() : null;
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: ShapeDecoration(
          color: AppTheme.buttonGrey,
          shape: CircleBorder(),
        ),
        child: Center(child: Icon(Icons.undo, size: 20, color: Colors.black)),
      ),
    );
  }
}
