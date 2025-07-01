part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final String userSelectedLeftSideSettingsListKey;

  const SettingsState({
    this.userSelectedLeftSideSettingsListKey = kProfileKey,
  });

  SettingsState copyWith({
    String? userSelectedLeftSideSettingsListKey,
  }) {
    return SettingsState(
      userSelectedLeftSideSettingsListKey:
          userSelectedLeftSideSettingsListKey ?? this.userSelectedLeftSideSettingsListKey,
    );
  }

  @override
  List<Object> get props => [
    userSelectedLeftSideSettingsListKey,
  ];
}
