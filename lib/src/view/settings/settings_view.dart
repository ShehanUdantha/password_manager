import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/settings/settings_cubit.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/constants/keys.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/view/settings/language_view.dart';
import 'package:pass_key/src/view/settings/profile_view.dart';
import 'package:pass_key/src/view/settings/settings_left_side_view.dart';
import 'package:pass_key/src/view/settings/theme_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previous, current) => previous.themeMode != current.themeMode,
        builder: (context, state) {
          final isDarkMode = checkIsDarkMode(context, state.themeMode);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: const SettingsLeftSideView(),
              ),
              Container(
                color: isDarkMode ? kDarkDividerColor : kLightDividerColor,
                width: 1.5,
              ),
              Expanded(
                flex: 5,
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  buildWhen:
                      (previous, current) =>
                          previous.userSelectedLeftSideSettingsListKey != current.userSelectedLeftSideSettingsListKey,
                  builder: (context, state) {
                    late Widget content;

                    switch (state.userSelectedLeftSideSettingsListKey) {
                      case kProfileKey:
                        content = const ProfileView();
                        break;
                      case kThemeKey:
                        content = const ThemeView();
                        break;
                      case kLanguageKey:
                        content = const LanguageView();
                        break;
                      default:
                        content = const SizedBox();
                    }

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: content,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
