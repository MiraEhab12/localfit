
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../homescreen.dart';
import '../onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  static const String routename='splashscreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoarding()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5C5646),
      body: Center(
          child: Image.asset("assets/images/splash.png")
      ),
    );
  }
}