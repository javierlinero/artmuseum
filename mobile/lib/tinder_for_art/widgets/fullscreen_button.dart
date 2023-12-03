// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/tinder_for_art/index.dart';

class FullscreenButton extends StatelessWidget {
  const FullscreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TinderArtBloc, ArtworkState>(
      builder: (context, artState) {
        if (artState.currentIndex >= artState.recommendations.length) {
          return Container();
        }
        return IconButton(
          icon: Icon(Icons.zoom_out_map, color: Colors.black),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FullScreenPhotoView(
                  imageUrl:
                      artState.recommendations[artState.currentIndex].imageUrl,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
