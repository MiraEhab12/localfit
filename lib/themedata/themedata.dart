import 'package:flutter/material.dart';
import 'package:localfit/appcolor/appcolors.dart';

class MyThemeData{
  static final ThemeData lighttheme=ThemeData(
    scaffoldBackgroundColor: AppColors.mainlightcolor,
primaryColor: AppColors.mainlightcolor,
appBarTheme: AppBarTheme(
  color: AppColors.mainlightcolor,
)
  );
}