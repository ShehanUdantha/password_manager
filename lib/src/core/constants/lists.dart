import 'package:flutter/material.dart';
import 'package:pass_key/src/core/constants/default_values.dart';
import 'package:pass_key/src/core/constants/keys.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/models/password_category_model.dart';

List<PasswordCategoryModel> listOfCategories(BuildContext context) => [
  PasswordCategoryModel(
    key: kEmailKey,
    label: context.loc.email,
    icon: Icons.email,
  ),
  PasswordCategoryModel(
    key: kBankingKey,
    label: context.loc.banking,
    icon: Icons.account_balance,
  ),
  PasswordCategoryModel(
    key: kSocialKey,
    label: context.loc.socialMedia,
    icon: Icons.people,
  ),
  PasswordCategoryModel(
    key: kShoppingKey,
    label: context.loc.shopping,
    icon: Icons.shopping_cart,
  ),
  PasswordCategoryModel(
    key: kEntertainmentKey,
    label: context.loc.entertainment,
    icon: Icons.movie,
  ),
  PasswordCategoryModel(
    key: kTravelKey,
    label: context.loc.travel,
    icon: Icons.flight,
  ),
  PasswordCategoryModel(
    key: kCloudKey,
    label: context.loc.cloudServices,
    icon: Icons.cloud,
  ),
  PasswordCategoryModel(
    key: kDeveloperKey,
    label: context.loc.developerTools,
    icon: Icons.code,
  ),
  PasswordCategoryModel(
    key: kMedicalKey,
    label: context.loc.medical,
    icon: Icons.local_hospital,
  ),
];

Map<String, String> categoryKeysMap(BuildContext context) => {
  kAllKey: context.loc.all,
  kFavoritesKey: context.loc.favorites,
  kEmailKey: context.loc.email,
  kBankingKey: context.loc.banking,
  kSocialKey: context.loc.socialMedia,
  kShoppingKey: context.loc.shopping,
  kEntertainmentKey: context.loc.entertainment,
  kTravelKey: context.loc.travel,
  kCloudKey: context.loc.cloudServices,
  kDeveloperKey: context.loc.developerTools,
  kMedicalKey: context.loc.medical,
};

List<PasswordCategoryModel> listOfSettings(BuildContext context) => [
  PasswordCategoryModel(
    key: kProfileKey,
    label: context.loc.profile,
    icon: Icons.account_circle_outlined,
  ),
  PasswordCategoryModel(
    key: kThemeKey,
    label: context.loc.theme,
    icon: Icons.color_lens_outlined,
  ),
  PasswordCategoryModel(
    key: kLanguageKey,
    label: context.loc.language,
    icon: Icons.translate_outlined,
  ),
];

Map<String, Map<String, dynamic>> listOfThemes(BuildContext context) => {
  kLightThemeName: {
    'theme_mode': kLightThemeMode,
    'title': context.loc.light,
  },
  kDarkThemeName: {
    'theme_mode': kDarkThemeMode,
    'title': context.loc.dark,
  },
  kSystemThemeName: {
    'theme_mode': kSystemThemeMode,
    'title': context.loc.system,
  },
};

const Map<String, Locale> listOfLanguages = {
  "English": Locale('en', 'US'),
  "Chinese": Locale('zh', 'CN'),
  "French": Locale('fr', 'FR'),
};
