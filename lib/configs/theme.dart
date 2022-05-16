import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:web_demo/models/model.dart';
import 'package:google_fonts/google_fonts.dart';

enum DarkOption { dynamic, alwaysOn, alwaysOff }

class AppTheme {
  ///Default font
/*  static String defaultFontFamily = "Open Sans";
  static TextTheme defaultTextTheme = GoogleFonts.openSansTextTheme();

  static Map<String,TextTheme> supportedTextThemes = {
    "Open Sans":GoogleFonts.openSansTextTheme(),
    "Roboto": GoogleFonts.robotoTextTheme(),
    "Oxygen":GoogleFonts.oxygenTextTheme()
  };*/

  /*
  "OpenSans",
    "ProximaNova",
    "Raleway",
    "Roboto",
    "Merriweather",
   */

  ///Default Theme
  static final ThemeModel defaultTheme = ThemeModel.fromJson({
    "name": "default",
    // "primary": 'ffe5634d',
    "primary": 'ff2777d8',
    "secondary": "ff2777d8",
    // "secondary": "ff4a91a4",
  });

  ///List Theme Support in Application
  static final List themeSupport = [
    {
      "name": "default",
      "primary": 'ffe5634d',
      "secondary": "ff4a91a4",
    },
    {
      "name": "green",
      "primary": 'ff82B541',
      "secondary": "ffff8a65",
    },
    {
      "name": "orange",
      "primary": 'fff4a261',
      "secondary": "ff2A9D8F",
    }
  ].map((item) => ThemeModel.fromJson(item)).toList();

  ///Dark Theme option
  static DarkOption darkThemeOption = DarkOption.dynamic;

  ///Singleton factory
  static final AppTheme _instance = AppTheme._internal();

  factory AppTheme() {
    return _instance;
  }

  AppTheme._internal();
}
