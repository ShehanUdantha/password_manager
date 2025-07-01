import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_key/src/core/constants/default_values.dart';
import 'package:pass_key/src/core/constants/lists.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}

String generatePassword() {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#-\$%^&*()';
  return List.generate(
    15,
    (index) => chars[Random().nextInt(chars.length)],
  ).join();
}

String? getCategoryLabelByKey(BuildContext context, String key) {
  final categoryMap = categoryKeysMap(context);
  final entry = categoryMap.entries.firstWhere(
    (element) => element.key == key,
    orElse: () => MapEntry('', ''),
  );
  return entry.value.isNotEmpty ? entry.value : null;
}

String formatDateTimeWithTime(DateTime? dateTime) {
  return dateTime != null ? DateFormat('d MMMM yyyy • h:mm a').format(dateTime) : "";
}

bool checkIsDarkMode(BuildContext context, ThemeMode themeMode) {
  if (themeMode == ThemeMode.system) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  return themeMode == kDarkThemeMode;
}
