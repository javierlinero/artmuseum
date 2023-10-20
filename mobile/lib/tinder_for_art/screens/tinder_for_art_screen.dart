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

  final List<String> artCards = [
    "https://puam-loris.aws.princeton.edu/loris/STU1350.jp2/full/full/0/default.jpg",
    "https://puam-loris.aws.princeton.edu/loris/1997-549.jp2/full/full/0/default.jpg",
    "https://puam-loris.aws.princeton.edu/loris/L1988-62-23.jp2/full/full/0/default.jpg",
    "https://puam-loris.aws.princeton.edu/loris/y1992-21.jp2/full/full/0/default.jpg",
    "https://puam-loris.aws.princeton.edu/loris/L1988-62-26.jp2/full/full/0/default.jpg"
  ];
  AppinioSwiperController _swiperController = AppinioSwiperController();

  @override
  Widget build(BuildContext context) {
    final appinioController = AppinioController(
      totalArtworks: artCards.length,
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
                      child: TinderUndoButton(
                          appinioController: appinioController, state: state)),
                ),
                Container(
                  height: swiperHeight,
                  alignment: Alignment.center,
                  child: TinderSwiper(
                      swiperController: _swiperController,
                      imageCards: artCards,
                      appinioController: appinioController),
                ),
                SizedBox(
                  height: buttonsHeight,
                  child: TinderButtonActionRow(
                      swiperController: _swiperController),
                )
              ],
            );
          }),
        );
      },
    );
  }
}
