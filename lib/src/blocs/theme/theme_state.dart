part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final String themeName;
  final ThemeMode themeMode;

  const ThemeState({
    this.themeName = kSystemThemeName,
    this.themeMode = kSystemThemeMode,
  });

  ThemeState copyWith({
    String? themeName,
    ThemeMode? themeMode,
    bool? isDarkMode,
  }) => ThemeState(
    themeName: themeName ?? this.themeName,
    themeMode: themeMode ?? this.themeMode,
  );

  @override
  List<Object> get props => [
    themeName,
    themeMode,
  ];
}
