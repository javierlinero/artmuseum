// ignore_for_file: prefer_const_constructors

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';

class TinderButtonActionRow extends StatelessWidget {
  const TinderButtonActionRow({
    super.key,
    required AppinioSwiperController swiperController,
  }) : _swiperController = swiperController;

  final AppinioSwiperController _swiperController;

  @override
  Widget build(BuildContext context) {
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
}
