import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/language/language_cubit.dart';
import 'package:pass_key/src/core/constants/lists.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/view/settings/widgets/theme_and_language_tile_widget.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<LanguageCubit, LanguageState>(
        buildWhen: (previous, current) => previous.languageLocale != current.languageLocale,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.loc.language,
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
                    itemCount: listOfLanguages.length,
                    itemBuilder: (_, index) {
                      final entry = listOfLanguages.entries.elementAt(index);
                      final languageName = entry.key;
                      final languageLocale = entry.value;
                      final isSelected = state.languageLocale == languageLocale;

                      return ThemeAndLanguageTileWidget(
                        title: languageName,
                        isSelected: isSelected,
                        onClickFunction:
                            () => _onClickLanguageUpdateButton(
                              context,
                              languageName,
                              languageLocale,
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

  void _onClickLanguageUpdateButton(
    BuildContext context,
    String languageName,
    Locale languageLocale,
  ) {
    context.read<LanguageCubit>().updateLanguage(languageName, languageLocale);
  }
}
