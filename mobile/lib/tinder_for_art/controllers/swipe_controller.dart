import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:puam_app/tinder_for_art/index.dart';

class AppinioController {
  final BuildContext context;
  final AppinioSwiperController swiperController;

  final Queue<int> _swipedIndexes = Queue<int>();

  AppinioController({required this.context, required this.swiperController});

  int get currentIndex {
    print(
        'Current Index accessed: ${context.read<ArtworkBloc>().state.currentIndex}');
    return context.read<ArtworkBloc>().state.currentIndex;
  }

  void handleSwipe(int index, AppinioSwiperDirection direction) {
    print('Handling Swipe: index = $index, direction = $direction');

    print('Adding $currentIndex to swipedIndexes');
    _swipedIndexes.addLast(currentIndex);

    int newIndex = currentIndex + 1;
    updateIndex(newIndex);
  }

  void updateIndex(int newIndex) {
    print('Updating Index to: $newIndex');
    context.read<ArtworkBloc>().add(UpdateArtworkIndex(newIndex));
  }

  void undoSwipe() {
    print('Trying to undo swipe.');

    if (_swipedIndexes.isNotEmpty) {
      int lastIndex = _swipedIndexes.removeLast();
      print('Removed last index from queue: $lastIndex');

      updateIndex(lastIndex);
      swiperController.unswipe();
    } else {
      print('No swiped indexes to undo.');
    }
  }
}
