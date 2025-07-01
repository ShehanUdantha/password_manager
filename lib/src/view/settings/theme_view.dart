import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/core/constants/lists.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/view/settings/widgets/theme_and_language_tile_widget.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previous, current) => previous.themeMode != current.themeMode,
        builder: (context, state) {
          final themeMap = listOfThemes(context);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.loc.theme,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: ListView.separated(
                    itemCount: themeMap.length,
                    itemBuilder: (_, index) {
                      final entry = themeMap.entries.elementAt(index);
                      final themeName = entry.key;
                      final themeMode = entry.value['theme_mode'] as ThemeMode;
                      final title = entry.value['title'] as String;

                      final isSelected = state.themeName == themeName;

                      return ThemeAndLanguageTileWidget(
                        title: title,
                        isSelected: isSelected,
                        onClickFunction:
                            () => _onClickThemeUpdateButton(
                              context,
                              themeName,
                              themeMode,
                            ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onClickThemeUpdateButton(
    BuildContext context,
    String themeName,
    ThemeMode themeMode,
  ) {
    context.read<ThemeCubit>().updateTheme(themeName, themeMode);
  }
}
