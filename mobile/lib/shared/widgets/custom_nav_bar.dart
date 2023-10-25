import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puam_app/art_of_the_day/index.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/tinder_for_art/index.dart';
import 'package:puam_app/user_profile/index.dart';

class CustomNavigationBar extends StatefulWidget {
  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = 0;
  Color princetonOrange = AppTheme.princetonOrange;

  final _featureScreens = [
    ArtOfTheDayPage(),
    TinderForArtPage(),
    const Placeholder(),
    const Placeholder(),
    const SignUpPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _featureScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/nav_bar/house.svg',
                width: 25,
                height: 25,
                color: _currentIndex == 0 ? princetonOrange : Colors.grey),
            activeIcon: SvgPicture.asset('assets/nav_bar/house.svg',
                width: 25, height: 25, color: princetonOrange),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/nav_bar/heart.svg',
                width: 25,
                height: 25,
                color: _currentIndex == 1 ? princetonOrange : Colors.grey),
            activeIcon: SvgPicture.asset('assets/nav_bar/heart.svg',
                width: 25, height: 25, color: princetonOrange),
            label: "Tinder",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/nav_bar/search.svg',
                width: 25,
                height: 25,
                color: _currentIndex == 2 ? princetonOrange : Colors.grey),
            activeIcon: SvgPicture.asset('assets/nav_bar/search.svg',
                width: 25, height: 25, color: princetonOrange),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/nav_bar/map.svg',
                width: 25,
                height: 25,
                color: _currentIndex == 3 ? princetonOrange : Colors.grey),
            activeIcon: SvgPicture.asset('assets/nav_bar/map.svg',
                width: 25, height: 25, color: princetonOrange),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/nav_bar/profile.svg',
                width: 25,
                height: 25,
                color: _currentIndex == 4 ? princetonOrange : Colors.grey),
            activeIcon: SvgPicture.asset('assets/nav_bar/profile.svg',
                width: 25, height: 25, color: princetonOrange),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
