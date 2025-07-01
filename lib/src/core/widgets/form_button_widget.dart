// ignore_for_file: public_member_api_docs, sort_constructors_first, dead_code
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/constants/sizes.dart';
import 'package:pass_key/src/core/utils/utils.dart';

class FormButtonWidget extends StatelessWidget {
  const FormButtonWidget({
    super.key,
    this.title,
    required this.onClickFunction,
    this.isOutLineButton = false,
    this.isLoading = false,
    this.customColor,
    this.focusNode,
    this.fontSize = 15.0,
  });

  final String? title;
  final Function onClickFunction;
  final bool isOutLineButton;
  final bool isLoading;
  final Color? customColor;
  final FocusNode? focusNode;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = checkIsDarkMode(context, state.themeMode);

        return OutlinedButton.icon(
          onPressed: () => onClickFunction(),
          focusNode: focusNode,
          style: OutlinedButton.styleFrom(
            elevation: 0,
            backgroundColor: isOutLineButton ? null : customColor ?? kLightSecondaryColor,
            side: BorderSide(
              color:
                  isOutLineButton
                      ? isDarkMode
                          ? kDarkContentColor.withValues(alpha: 0.5)
                          : kMediumLightGreyColor
                      : Colors.transparent,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: kButtonHeight,
              horizontal: 10.0,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kButtonRadius)),
          ),
          label:
              isLoading
                  ? SizedBox(
                    height: 20.0,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineScale,
                      colors: [
                        isOutLineButton
                            ? isDarkMode
                                ? kDarkContentColor
                                : kLightContentColor
                            : kWhiteColor,
                      ],
                      backgroundColor: Colors.transparent,
                      pathBackgroundColor: Colors.transparent,
                    ),
                  )
                  : Text(
                    title ?? "",
                    style: TextStyle(
                      fontSize: fontSize,
                      color:
                          isOutLineButton
                              ? isDarkMode
                                  ? kDarkContentColor
                                  : kLightContentColor
                              : kWhiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
        );
      },
    );
  }
}
