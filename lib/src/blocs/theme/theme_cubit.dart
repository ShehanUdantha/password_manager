import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/core/constants/default_values.dart';
import 'package:pass_key/src/core/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeCubit(this.sharedPreferences) : super(ThemeState()) {
    getCurrentTheme();
  }

  void updateTheme(String themeName, ThemeMode themeMode) async {
    await sharedPreferences.setString(kThemePreferenceKey, themeName);

    emit(
      state.copyWith(
        themeName: themeName,
        themeMode: themeMode,
      ),
    );
  }

  void getCurrentTheme() {
    final savedTheme = sharedPreferences.getString(kThemePreferenceKey) ?? kSystemThemeName;

    switch (savedTheme) {
      case kLightThemeName:
        emit(
          state.copyWith(
            themeName: kLightThemeName,
            themeMode: kLightThemeMode,
          ),
        );
        break;
      case kDarkThemeName:
        emit(
          state.copyWith(
            themeName: kDarkThemeName,
            themeMode: kDarkThemeMode,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            themeName: kSystemThemeName,
            themeMode: kSystemThemeMode,
          ),
        );
    }
  }
}
