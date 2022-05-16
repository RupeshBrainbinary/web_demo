import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';

class UtilTheme {
  static ThemeData getTheme({
    required ThemeModel theme,
    required Brightness brightness,
    //required String font,
    required TextTheme textTheme,
  }) {
    ColorScheme? colorScheme;
    switch (brightness) {
      case Brightness.light:
        colorScheme = ColorScheme.light(
          primary: theme.primary,
          secondary: theme.secondary,
          background: const Color.fromRGBO(249, 249, 249, 1),
        );
        break;
      case Brightness.dark:
        colorScheme = ColorScheme.dark(
          primary: theme.primary,
          secondary: theme.secondary,
          background: const Color.fromRGBO(23, 24, 25, 1),
        );
        break;
      default:
    }

    final isDark = colorScheme!.brightness == Brightness.dark;
    final indicatorColor = isDark ? colorScheme.onSurface : colorScheme.primary;

    return ThemeData(
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      primaryColorBrightness: colorScheme.brightness,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: isDark ? Colors.white : Colors.black,
        shadowColor: isDark ? null : colorScheme.onSurface.withOpacity(0.2),
      ),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      bottomAppBarColor: colorScheme.surface,
      cardColor: colorScheme.surface,
      dividerColor: colorScheme.onSurface.withOpacity(0.12),
      backgroundColor: colorScheme.background,
      dialogBackgroundColor: colorScheme.background,
      errorColor: colorScheme.error,
      indicatorColor: indicatorColor,
      applyElevationOverlayColor: isDark,
      colorScheme: colorScheme,
      //fontFamily: font,
      textTheme: textTheme,
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 0.8,
        space: 0,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        shape: CircularNotchedRectangle(),
      ),
    );
  }

  static String langDarkOption(DarkOption option) {
    switch (option) {
      case DarkOption.dynamic:
        return "dynamic_theme";
      case DarkOption.alwaysOff:
        return "always_off";
      default:
        return "always_on";
    }
  }

  ///Singleton factory
  static final _instance = UtilTheme._internal();

  factory UtilTheme() {
    return _instance;
  }

  UtilTheme._internal();
}
