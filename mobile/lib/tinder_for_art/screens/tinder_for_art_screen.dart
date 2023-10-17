// ignore_for_file: prefer_const_constructors

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
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  final List<Color> colorCards = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];
  AppinioSwiperController _swiperController = AppinioSwiperController();

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
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double swiperHeight = constraints.maxHeight * 0.7;
            double buttonsHeight = constraints.maxHeight * 0.25;
            double undoHeight = constraints.maxHeight * 0.05;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth(context) * 0.05),
                  child: SizedBox(
                      height: undoHeight,
                      child: _undoButton(appinioController, state)),
                ),
                Container(
                  height: swiperHeight,
                  alignment: Alignment.center,
                  child: _buildSwiper(appinioController),
                ),
                SizedBox(
                  height: buttonsHeight,
                  child: _buildButtonRow(),
                )
              ],
            );
          }),
        );
      },
    );
  }

  GestureDetector _undoButton(
      AppinioController appinioController, ArtworkState state) {
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

  Row _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            _swiperController.swipeLeft();
          },
          child: Container(
            width: 75,
            height: 75,
            decoration: ShapeDecoration(
              color: AppTheme.buttonGrey,
              shape: OvalBorder(),
            ),
            child: Center(
                child: Icon(Icons.thumb_down,
                    size: 40, color: Colors.red.withOpacity(0.75))),
          ),
        ),
        GestureDetector(
          onTap: () {
            _swiperController.swipeUp();
          },
          child: Container(
            width: 75,
            height: 75,
            decoration: ShapeDecoration(
              color: AppTheme.buttonGrey,
              shape: OvalBorder(),
            ),
            child: Center(
                child: Icon(Icons.horizontal_rule_outlined,
                    size: 40, color: Colors.grey)),
          ),
        ),
        GestureDetector(
          onTap: () {
            _swiperController.swipeRight();
          },
          child: Container(
            width: 75,
            height: 75,
            decoration: ShapeDecoration(
              color: AppTheme.buttonGrey,
              shape: OvalBorder(),
            ),
            child: Center(
                child: Icon(Icons.thumb_up,
                    size: 40, color: Colors.green.withOpacity(0.75))),
          ),
        ),
      ],
    );
  }

  AppinioSwiper _buildSwiper(AppinioController appinioController) {
    return AppinioSwiper(
      swipeOptions: const AppinioSwipeOptions.only(
        left: true,
        right: true,
        bottom: false,
        top: true,
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
    );
  }
}
