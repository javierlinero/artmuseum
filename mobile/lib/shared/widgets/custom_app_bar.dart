import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

AppBar appBar() {
  return AppBar(
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    elevation: 0,
    title: SizedBox(
      width: 200,
      child: SvgPicture.asset(
        'assets/logo/puam.svg',
      ),
    ),
    centerTitle: true,
  );
}
