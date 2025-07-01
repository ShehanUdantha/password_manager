import 'package:flutter/material.dart';
import 'package:pass_key/l10n/generated/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}
