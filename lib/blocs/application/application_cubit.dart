import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/utils/utils.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationState.loading);

  ///On Setup Application
  void onSetup() async {
    ///Notify loading
    emit(ApplicationState.loading);

    ///Firebase init
    await Firebase.initializeApp();

    ///Setup SharedPreferences
    await Preferences.setPreferences();

    ///Get old Theme & Font & Language
    final oldTheme = UtilPreferences.getString(Preferences.theme);
/*    final oldFont = UtilPreferences.getString(Preferences.font) ??
        AppTheme.defaultFontFamily;*/
    final oldLanguage = UtilPreferences.getString(Preferences.language);
    final oldDarkOption = UtilPreferences.getString(Preferences.darkOption);

    DarkOption? darkOption;
    TextTheme? textTheme;
    ThemeModel? theme;

    ///Setup Language
    if (oldLanguage != null) {
      AppBloc.languageCubit.onUpdate(Locale(oldLanguage));
    }

    ///Find font support available [Dart null safety issue]
    // try {
    //   textTheme = AppTheme.supportedTextThemes[oldFont];
    // } catch (e) {
    //   UtilLogger.log("ERROR", e);
    // }

    if (oldTheme != null) {
      try {
        theme = ThemeModel.fromJson(jsonDecode(oldTheme));
      } catch (e) {
        UtilLogger.log("ERROR", e);
      }
    }

    ///check old dark option
    if (oldDarkOption != null) {
      switch (oldDarkOption) {
        case 'off':
          darkOption = DarkOption.alwaysOff;
          break;
        case 'on':
          darkOption = DarkOption.alwaysOn;
          break;
        default:
          darkOption = DarkOption.alwaysOn;
      }
    }

    ///Setup Theme & Font with dark Option
    AppBloc.themeCubit.onChangeTheme(
      theme: theme,
      textTheme: textTheme,
      darkOption: darkOption,
    );

    ///Authentication begin check
    await AppBloc.authenticateCubit.onCheck();

    ///First or After upgrade version show intro preview app
    final hasReview = UtilPreferences.containsKey(
      '${Preferences.reviewIntro}.${Application.version}',
    );
    if (hasReview) {
      ///Notify
      Future.delayed(Duration(seconds: 3),(){
        emit(ApplicationState.completed);
      });
    } else {
      ///Notify
      emit(ApplicationState.intro);
    }

    ///load categories
    //await AppBloc.categoryCubit.loadCategories();
  }

  ///On Complete Intro
  void onCompletedIntro() async {
    await UtilPreferences.setBool(
      '${Preferences.reviewIntro}.${Application.version}',
      true,
    );

    ///Notify
    emit(ApplicationState.completed);
  }
}
