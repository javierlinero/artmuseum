import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:puam_app/shared/index.dart';
// import 'package:puam_app/shared/index.dart';
import 'package:puam_app/tinder_for_art/index.dart';

class TinderSwiper extends StatelessWidget {
  const TinderSwiper({
    super.key,
    required AppinioSwiperController swiperController,
    required this.imageCards,
    required this.appinioController,
  }) : _swiperController = swiperController;

  final AppinioSwiperController _swiperController;
  final List<TinderArt> imageCards;
  final AppinioController appinioController;

  @override
  Widget build(BuildContext context) {
    return AppinioSwiper(
      backgroundCardsCount: 0,
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
            CachedNetworkImage(
              imageUrl:
                  '${imageCards[index].imageUrl}/full/pct:15/0/default.jpg',
              fit: BoxFit.fill,
              placeholder: (context, url) => CircularProgressIndicator(
                color: AppTheme.princetonOrange,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
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
