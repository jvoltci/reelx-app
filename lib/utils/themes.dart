import 'package:flutter/material.dart';
import 'package:reelx/utils/styles.dart';

class Themes {
  static ThemeData _baseTheme({
    required bool isDarkMode,
    required TextStyle bodySmall,
    required TextStyle displayLarge,
    required TextStyle displayMedium,
    required TextStyle displaySmall,
    required TextStyle headlineMedium,
    required TextStyle headlineSmall,
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color cardColor,
    required Color primaryColor,
    required Color appBarShadowColor,
    required Color cardShadowColor,
    required Color shadowColor,
  }) {
    return ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(shadowColor: appBarShadowColor),
      cardTheme: CardTheme(shadowColor: cardShadowColor),
      textTheme: TextTheme(
        bodySmall: bodySmall,
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
      ),
      primaryColor: primaryColor,
      shadowColor: shadowColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      colorScheme: colorScheme,
    );
  }

  static final light = _baseTheme(
    isDarkMode: false,
    bodySmall: const TextStyle(fontFamily: 'Rancho'),
    displayLarge: TextStyle(color: Styles.headline1Color),
    displayMedium: TextStyle(color: Styles.headline2Color),
    displaySmall: TextStyle(color: Styles.headline3Color),
    headlineMedium: TextStyle(color: Styles.headline4Color),
    headlineSmall: TextStyle(color: Styles.headline5Color),
    colorScheme: ColorScheme.light(background: Styles.secondaryBackgrondColor),
    scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
    cardColor: Styles.cardBackgroundColor,
    primaryColor: Styles.primaryBackgroundColor,
    appBarShadowColor: Styles.appBarShadowColor,
    cardShadowColor: Styles.cardShadowColor,
    shadowColor: Styles.cardShadowColor,
  );

  static final dark = _baseTheme(
    isDarkMode: true,
    bodySmall: const TextStyle(fontFamily: 'Rancho'),
    displayLarge: TextStyle(color: Styles.headline1ColorDark),
    displayMedium: TextStyle(color: Styles.headline2ColorDark),
    displaySmall: TextStyle(color: Styles.headline3ColorDark),
    headlineMedium: TextStyle(color: Styles.headline4ColorDark),
    headlineSmall: TextStyle(color: Styles.headline5ColorDark),
    colorScheme:
        ColorScheme.dark(background: Styles.secondaryBackgrondColorDark),
    scaffoldBackgroundColor: Styles.scaffoldBackgroundColorDark,
    cardColor: Styles.cardBackgroundColorDark,
    primaryColor: Styles.primaryBackgroundColorDark,
    appBarShadowColor: Styles.appBarShadowColor,
    cardShadowColor: Styles.cardShadowColorDark,
    shadowColor: Styles.cardShadowColorDark,
  );
}
