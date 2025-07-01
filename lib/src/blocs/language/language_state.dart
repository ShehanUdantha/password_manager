part of 'language_cubit.dart';

class LanguageState extends Equatable {
  final String languageName;
  final Locale languageLocale;

  const LanguageState({
    this.languageName = kDefaultLanguageName,
    this.languageLocale = kDefaultLanguageLocale,
  });

  LanguageState copyWith({
    String? languageName,
    Locale? languageLocale,
  }) => LanguageState(
    languageName: languageName ?? this.languageName,
    languageLocale: languageLocale ?? this.languageLocale,
  );

  @override
  List<Object> get props => [
    languageName,
    languageLocale,
  ];
}
