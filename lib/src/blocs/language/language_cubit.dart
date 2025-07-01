// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/core/constants/keys.dart';
import 'package:pass_key/src/core/constants/lists.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pass_key/src/core/constants/default_values.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final SharedPreferences sharedPreferences;

  LanguageCubit(
    this.sharedPreferences,
  ) : super(LanguageState()) {
    getCurrentLanguage();
  }

  void updateLanguage(
    String languageName,
    Locale languageLocale,
  ) async {
    await sharedPreferences.setString(kLanguagePreferenceKey, languageName);

    emit(
      state.copyWith(
        languageName: languageName,
        languageLocale: languageLocale,
      ),
    );
  }

  void getCurrentLanguage() {
    String? savedLanguageName = sharedPreferences.getString(kLanguagePreferenceKey);

    if (savedLanguageName != null) {
      final savedLanguageLocale = listOfLanguages[savedLanguageName] ?? kDefaultLanguageLocale;

      emit(
        state.copyWith(
          languageName: savedLanguageName,
          languageLocale: savedLanguageLocale,
        ),
      );
    }
  }
}
