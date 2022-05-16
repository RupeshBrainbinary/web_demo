import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/utils/utils.dart';

class ThemeState {
  final ThemeModel theme;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final TextTheme textTheme;
  final String fontFamily;
  final DarkOption darkOption;

  ThemeState({
    required this.theme,
    required this.lightTheme,
    required this.darkTheme,
    required this.textTheme,
    required this.fontFamily,
    required this.darkOption,
  });

  factory ThemeState.fromDefault() {
    return ThemeState(
      theme: AppTheme.defaultTheme,
      lightTheme: UtilTheme.getTheme(
        theme: AppTheme.defaultTheme,
        brightness: Brightness.light,
        textTheme: TextTheme(subtitle1: TextStyle(fontFamily: "ProximaNova")),
      ),
      darkTheme: UtilTheme.getTheme(
        theme: AppTheme.defaultTheme,
        brightness: Brightness.dark,
        textTheme: TextTheme(subtitle1: TextStyle(fontFamily: "ProximaNova")),
      ),
      textTheme:  TextTheme(subtitle1: TextStyle(fontFamily: "ProximaNova")),
      fontFamily: "ProximaNova",
      //fontFamily: "ProximaNova",
      darkOption: AppTheme.darkThemeOption,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.fromDefault());

  void onChangeTheme({
    ThemeModel? theme,
    TextTheme? textTheme,
    String? fontFamily,
    DarkOption? darkOption,
  }) async {
    ///Setup Theme with setting darkOption
    final currentState = AppBloc.themeCubit.state;
    theme ??= currentState.theme;
    textTheme ??= currentState.textTheme;
    fontFamily ??= currentState.fontFamily;
    darkOption ??= currentState.darkOption;

    ThemeState themeState;

    switch (darkOption) {
      case DarkOption.dynamic:
        UtilPreferences.setString(Preferences.darkOption, 'dynamic');
        themeState = ThemeState(
          theme: theme,
          lightTheme: UtilTheme.getTheme(
            theme: theme,
            brightness: Brightness.light,
            textTheme: textTheme,
          ),
          darkTheme: UtilTheme.getTheme(
            theme: theme,
            brightness: Brightness.dark,
            textTheme: textTheme,
          ),
          textTheme: textTheme,
          fontFamily: fontFamily,
          darkOption: darkOption,
        );
        break;
      case DarkOption.alwaysOn:
        UtilPreferences.setString(Preferences.darkOption, 'on');
        themeState = ThemeState(
          theme: theme,
          lightTheme: UtilTheme.getTheme(
            theme: theme,
            brightness: Brightness.dark,
            textTheme: textTheme,
          ),
          darkTheme: UtilTheme.getTheme(
            theme: theme,
            brightness: Brightness.dark,
            textTheme: textTheme,
          ),
          textTheme: textTheme,
          fontFamily: fontFamily,
          darkOption: darkOption,
        );
        break;
      case DarkOption.alwaysOff:
        UtilPreferences.setString(Preferences.darkOption, 'off');
        themeState = ThemeState(
          theme: theme,
          lightTheme: UtilTheme.getTheme(
            theme: theme,
            brightness: Brightness.light,
            textTheme: textTheme,
          ),
          darkTheme: UtilTheme.getTheme(
            theme: theme,
            brightness: Brightness.light,
            textTheme: textTheme,
          ),
          textTheme: textTheme,
          fontFamily: fontFamily,
          darkOption: darkOption,
        );
        break;
    }

    ///Preference save
    UtilPreferences.setString(
      Preferences.theme,
      jsonEncode(themeState.theme.toJson()),
    );

    ///Preference save
    UtilPreferences.setString(Preferences.font, themeState.fontFamily);

    ///Notify
    emit(themeState);
  }
}
