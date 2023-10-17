import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/tinder_for_art/bloc/index.dart';

class ArtworkController {
  final BuildContext context;

  ArtworkController(this.context);

  int get currentIndex => context.read<ArtworkBloc>().state.currentIndex;

  void updateIndex(int newIndex) {
    context.read<ArtworkBloc>().add(UpdateArtworkIndex(newIndex));
  }
}
