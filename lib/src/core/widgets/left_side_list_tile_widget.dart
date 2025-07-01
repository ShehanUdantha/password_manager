import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/utils/utils.dart';

class LeftSideListTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onClickFunction;
  final Key? valueKey;

  const LeftSideListTileWidget({
    super.key,
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onClickFunction,
    this.valueKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = checkIsDarkMode(context, state.themeMode);

        return InkWell(
          key: valueKey,
          onTap: () => onClickFunction(),
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? isDarkMode
                          ? kDarkDividerColor
                          : kLightDividerColor
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18.0,
                  color: isDarkMode ? kDarkContentColor : kLightContentColor,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
