// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/constants/default_values.dart';
import 'package:pass_key/src/core/constants/sizes.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/core/utils/utils.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.focusNode,
    this.isNumber = false,
    this.isReadOnly = false,
    this.maxLines = 1,
    this.onTapFunction,
    this.onChangeFunction,
    this.suffixIcon,
    this.prefixIcon,
    required this.hintText,
    this.isRequired = true,
    this.inputFormatters,
    this.initialValue,
    this.isValidNumber = false,
    this.isPassword = false,
    this.fontSize = 14.0,
    this.hintSize = 12.0,
    this.paddingVertical = 15.0,
    this.paddingHorizontal = 20.0,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isNumber;
  final bool isReadOnly;
  final int maxLines;
  final Function? onTapFunction;
  final Function(String)? onChangeFunction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String hintText;
  final bool isRequired;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool isValidNumber;
  final bool isPassword;
  final double fontSize;
  final double hintSize;
  final double paddingVertical;
  final double paddingHorizontal;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = checkIsDarkMode(context, state.themeMode);

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          readOnly: isReadOnly,
          maxLines: maxLines,
          initialValue: initialValue,
          obscureText: isPassword,
          onTap: () => onTapFunction != null ? onTapFunction!() : {},
          validator: (value) {
            if (isRequired) {
              if (value == null || value.isEmpty) {
                return context.loc.pleaseFillOutThisField;
              }
            }
            if (isValidNumber) {
              if ((double.tryParse(value ?? "0") ?? 0) <= 0) {
                return context.loc.pleaseEnterTheValidValue;
              }
            }

            if (isPassword) {
              if ((value?.length ?? 0) < kUserPasswordLength) {
                return context.loc.passwordLengthMustBeSixCharactersLong;
              }
            }
            return null;
          },
          inputFormatters: inputFormatters,

          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            errorMaxLines: 3,
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: hintSize,
              fontWeight: FontWeight.w400,
              color: isDarkMode ? kDarkContentColor.withValues(alpha: 0.5) : kLightContentColor.withValues(alpha: 0.8),
            ),
            errorStyle: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: kErrorColor,
            ),
            border: const OutlineInputBorder().copyWith(
              borderRadius: BorderRadius.circular(kInputFieldRadius),
              borderSide: BorderSide(width: 1, color: isDarkMode ? kDarkGreyColor : kLightGreyColor),
            ),
            enabledBorder: const OutlineInputBorder().copyWith(
              borderRadius: BorderRadius.circular(kInputFieldRadius),
              borderSide: BorderSide(width: 1, color: isDarkMode ? kDarkGreyColor : kLightGreyColor),
            ),
            focusedBorder: const OutlineInputBorder().copyWith(
              borderRadius: BorderRadius.circular(kInputFieldRadius),
              borderSide: BorderSide(width: 1, color: kAppGreenColor.withValues(alpha: 0.5)),
            ),
            errorBorder: const OutlineInputBorder().copyWith(
              borderRadius: BorderRadius.circular(kInputFieldRadius),
              borderSide: BorderSide(width: 1, color: kErrorColor.withValues(alpha: 0.8)),
            ),
            focusedErrorBorder: const OutlineInputBorder().copyWith(
              borderRadius: BorderRadius.circular(kInputFieldRadius),
              borderSide: BorderSide(width: 1, color: kErrorColor.withValues(alpha: 0.8)),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: paddingVertical,
              horizontal: paddingHorizontal,
            ),
          ),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? kDarkContentColor : kLightContentColor,
          ),
          onChanged: onChangeFunction,
        );
      },
    );
  }
}
