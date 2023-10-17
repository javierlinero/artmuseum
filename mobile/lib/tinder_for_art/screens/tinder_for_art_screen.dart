import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/tinder_for_art/index.dart';

class TinderForArtPage extends StatefulWidget {
  @override
  _TinderForArtPageState createState() => _TinderForArtPageState();
}

class _TinderForArtPageState extends State<TinderForArtPage> {
  final List<Color> colorCards = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];
  AppinioSwiperController _swiperController = AppinioSwiperController();

  bool _isUndoButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    final appinioController = AppinioController(
      context: context,
      swiperController: _swiperController,
    );

    return BlocBuilder<ArtworkBloc, ArtworkState>(
      builder: (context, state) {
        return Scaffold(
          appBar: appBar(),
          body: Center(
            child: AppinioSwiper(
              swipeOptions: const AppinioSwipeOptions.only(
                left: true,
                right: true,
                bottom: true,
                top: false,
              ),
              unlimitedUnswipe: true,
              controller: _swiperController,
              cardsBuilder: (BuildContext context, int index) {
                return Center(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.6,
                  color: colorCards[index],
                ));
              },
              cardsCount: colorCards.length,
              onSwipe: (index, direction) {
                appinioController.handleSwipe(index, direction);
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.undo),
            onPressed: state.canUndo ? appinioController.undoSwipe : null,
          ),
        );
      },
    );
  }
}
