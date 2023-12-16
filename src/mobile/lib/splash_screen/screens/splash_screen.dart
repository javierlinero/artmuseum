import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puam_app/shared/index.dart';

class MySplashScreen extends StatefulWidget {
  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.scale(
      backgroundColor: Colors.white,
      childWidget: SizedBox(
        height: 200,
        child: SvgPicture.asset("assets/logo/puam.svg"),
      ),
      duration: const Duration(milliseconds: 1500),
      animationDuration: const Duration(milliseconds: 800),
      onAnimationEnd: () => debugPrint("On Scale End"),
      nextScreen: CustomNavigationBar(),
    );
  }
}
