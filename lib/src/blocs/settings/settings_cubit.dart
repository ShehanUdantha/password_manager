import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/core/constants/keys.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void updateUserSelectedLeftSideSettingsListKey(String key) async {
    if (state.userSelectedLeftSideSettingsListKey != key) {
      emit(
        state.copyWith(userSelectedLeftSideSettingsListKey: key),
      );
    }
  }
}
