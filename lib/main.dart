import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:localfit/homescreen.dart';
import 'package:localfit/log_in/forgotpassword.dart';
import 'package:localfit/log_in/register.dart';
import 'package:localfit/log_in/sign_in.dart';
import 'package:localfit/onboarding/onboarding.dart';
import 'package:localfit/shop_now.dart';
import 'dart:async';

import 'package:localfit/splash/SplashScreen.dart';
import 'package:localfit/themedata/themedata.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: MyThemeData.lighttheme,
      theme: MyThemeData.lighttheme,
      debugShowCheckedModeBanner: false,
     initialRoute:SplashScreen.routename ,
      routes: {
        SplashScreen.routename:(context)=>SplashScreen(),
        OnBoarding.routename:(context)=>OnBoarding(),
        HomeScreen.routename:(context)=>HomeScreen(),
        ShopNow.routename:(context)=>ShopNow(),
        RegisterScreen.routename:(context)=>RegisterScreen(),
        SignInScreen.routename:(context)=>SignInScreen(),
        ForgotPasswordScreen.routename:(context)=>ForgotPasswordScreen(),
      },
    );
  }
}

