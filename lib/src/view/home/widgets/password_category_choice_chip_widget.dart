// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';

import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/utils/utils.dart';

class PasswordCategoryChoiceChipWidget extends StatelessWidget {
  const PasswordCategoryChoiceChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelectFunction,
  });

  final String label;
  final bool isSelected;
  final Function onSelectFunction;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = checkIsDarkMode(context, state.themeMode);

        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          side: BorderSide(color: isDarkMode ? kDarkGreyColor : kLightGreyColor),
          backgroundColor: isDarkMode ? kDarkDividerColor : kLightDividerColor,
          selectedColor: isDarkMode ? kAppGreenColor.withValues(alpha: 0.7) : kAppGreenColor.withValues(alpha: 0.1),
          labelStyle: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
          ),
          onSelected: (_) => onSelectFunction(),
        );
      },
    );
  }
}
