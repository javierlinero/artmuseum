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
  final List<Color> colorCards = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
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
            double buttonsHeight = constraints.maxHeight * 0.3;
            return Column(
              children: [
                Container(
                  height: swiperHeight,
                  alignment: Alignment.center,
                  child: _buildSwiper(appinioController),
                ),
                Container(
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
                child: Icon(Icons.thumb_down, size: 40, color: Colors.red)),
          ),
        ),
        GestureDetector(
          onTap: () {
            _swiperController.swipeDown();
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
                child: Icon(Icons.thumb_up, size: 40, color: Colors.green)),
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
    );
  }
}
