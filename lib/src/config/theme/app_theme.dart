import 'package:flutter/material.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kLightPrimaryColor,
    scaffoldBackgroundColor: kLightPrimaryColor,
    iconTheme: const IconThemeData(color: kLightContentColor),
    textTheme: ThemeData().textTheme.apply(
      bodyColor: kLightContentColor,
    ),
    colorScheme: const ColorScheme.light(
      primary: kLightPrimaryColor,
      secondary: kLightSecondaryColor,
      error: kErrorColor,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kLightSecondaryColor,
      selectionHandleColor: kLightSecondaryColor,
    ),
    dividerTheme: const DividerThemeData(color: kLightDividerColor),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kDarkPrimaryColor,
    scaffoldBackgroundColor: kDarkPrimaryColor,
    iconTheme: const IconThemeData(color: kDarkContentColor),
    textTheme: ThemeData().textTheme.apply(
      bodyColor: kDarkContentColor,
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: kDarkPrimaryColor,
      secondary: kDarkSecondaryColor,
      error: kErrorColor,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kDarkSecondaryColor,
      selectionHandleColor: kDarkSecondaryColor,
    ),
    dividerTheme: const DividerThemeData(color: kDarkDividerColor),
  );
}
