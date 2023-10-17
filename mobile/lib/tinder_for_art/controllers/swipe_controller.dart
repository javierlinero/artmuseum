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
    debugPrint(
        'Current Index accessed: ${context.read<ArtworkBloc>().state.currentIndex}');
    return context.read<ArtworkBloc>().state.currentIndex;
  }

  void handleSwipe(int index, AppinioSwiperDirection direction) {
    debugPrint('Handling Swipe: index = $index, direction = $direction');

    debugPrint('Adding $currentIndex to swipedIndexes');
    _swipedIndexes.addLast(currentIndex);

    int newIndex = currentIndex + 1;
    updateIndex(newIndex);
  }

  void updateIndex(int newIndex) {
    debugPrint('Updating Index to: $newIndex');
    context.read<ArtworkBloc>().add(UpdateArtworkIndex(newIndex));
  }

  void swipeLeft() {
    swiperController.swipeLeft();
    handleSwipe(currentIndex, AppinioSwiperDirection.left);
  }

  void swipeDown() {
    swiperController.swipeDown();
    handleSwipe(currentIndex, AppinioSwiperDirection.bottom);
  }

  void swipeRight() {
    swiperController.swipeRight();
    handleSwipe(currentIndex, AppinioSwiperDirection.right);
  }

  void undoSwipe() {
    debugPrint('Trying to undo swipe.');

    if (_swipedIndexes.isNotEmpty) {
      int lastIndex = _swipedIndexes.removeLast();
      debugPrint('Removed last index from queue: $lastIndex');
      updateIndex(lastIndex);
      swiperController.unswipe();
      context.read<ArtworkBloc>().add(ToggleUndo(false));

      Future.delayed(Duration(milliseconds: 500), () {
        context.read<ArtworkBloc>().add(ToggleUndo(true));
      });
    } else {
      debugPrint('No swiped indexes to undo.');
    }
  }
}
