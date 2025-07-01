import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/auth/auth_bloc.dart';
import 'package:pass_key/src/blocs/password/password_bloc.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/config/routes/route_names.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/constants/keys.dart';
import 'package:pass_key/src/core/constants/lists.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/models/password_category_model.dart';
import 'package:pass_key/src/core/widgets/left_side_list_tile_widget.dart';

class HomeLeftSideView extends StatefulWidget {
  const HomeLeftSideView({super.key});

  @override
  State<HomeLeftSideView> createState() => _HomeLeftSideViewState();
}

class _HomeLeftSideViewState extends State<HomeLeftSideView> {
  late List<PasswordCategoryModel> _categories;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categories = listOfCategories(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = checkIsDarkMode(context, state.themeMode);

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 7.0,
            horizontal: 8.0,
          ).copyWith(bottom: 5.0),
          child: BlocBuilder<PasswordBloc, PasswordState>(
            buildWhen:
                (previous, current) =>
                    previous.userSelectedLeftSideCategoryListKey != current.userSelectedLeftSideCategoryListKey,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: LeftSideListTileWidget(
                      icon: Icons.vpn_key,
                      title: context.loc.all,
                      isSelected: state.userSelectedLeftSideCategoryListKey == kAllKey,
                      onClickFunction: () => _onClickTileButton(kAllKey),
                      valueKey: const ValueKey(kAllKey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: LeftSideListTileWidget(
                      icon: Icons.star_border_outlined,
                      title: context.loc.favorites,
                      isSelected: state.userSelectedLeftSideCategoryListKey == kFavoritesKey,
                      onClickFunction: () => _onClickTileButton(kFavoritesKey),
                      valueKey: const ValueKey(kFavoritesKey),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ReorderableListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final item = _categories[index];
                        final itemKey = item.key;
                        final isSelected = state.userSelectedLeftSideCategoryListKey == itemKey;

                        return ReorderableDragStartListener(
                          index: index,
                          key: ValueKey(itemKey),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Material(
                              color:
                                  isSelected
                                      ? isDarkMode
                                          ? kDarkDividerColor
                                          : kLightDividerColor
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                              child: LeftSideListTileWidget(
                                icon: item.icon,
                                title: item.label,
                                isSelected: isSelected,
                                onClickFunction: () => _onClickTileButton(itemKey),
                                valueKey: ValueKey(itemKey),
                              ),
                            ),
                          ),
                        );
                      },
                      onReorder: _onReorderMethod,
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: LeftSideListTileWidget(
                      icon: Icons.settings,
                      title: context.loc.settings,
                      onClickFunction: () => _onClickSettingsButton(),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _onReorderMethod(oldIndex, newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _categories.removeAt(oldIndex);
      _categories.insert(newIndex, item);
    });
  }

  void _onClickTileButton(String key) {
    context.read<PasswordBloc>().add(
      UpdateUserSelectedLeftSideCategoryListKey(
        key: key,
        uid: context.read<AuthBloc>().state.userModel?.id,
      ),
    );
  }

  void _onClickSettingsButton() {
    Navigator.pushNamed(context, settingsRoute);
  }
}
