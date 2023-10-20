import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:puam_app/tinder_for_art/index.dart';

class TinderSwiper extends StatelessWidget {
  const TinderSwiper({
    super.key,
    required AppinioSwiperController swiperController,
    required this.imageCards,
    required this.appinioController,
  }) : _swiperController = swiperController;

  final AppinioSwiperController _swiperController;
  final List<String> imageCards;
  final AppinioController appinioController;

  @override
  Widget build(BuildContext context) {
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
          child: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Image.network(imageCards[index]),
            )
          ]),
        );
      },
      cardsCount: imageCards.length,
      onSwipe: (index, direction) {
        appinioController.handleSwipe(index, direction);
      },
    );
  }
}
