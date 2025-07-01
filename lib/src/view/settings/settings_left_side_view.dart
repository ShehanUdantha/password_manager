import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/auth/auth_bloc.dart';
import 'package:pass_key/src/blocs/password/password_bloc.dart';
import 'package:pass_key/src/blocs/settings/settings_cubit.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/config/routes/route_names.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/constants/keys.dart';
import 'package:pass_key/src/core/constants/lists.dart';
import 'package:pass_key/src/core/utils/enums.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/core/widgets/form_button_widget.dart';
import 'package:pass_key/src/core/widgets/left_side_list_tile_widget.dart';

class SettingsLeftSideView extends StatelessWidget {
  const SettingsLeftSideView({super.key});

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
          child: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == BlocStatus.success) {
                context.read<PasswordBloc>().add(InitPasswordBloc());
                context.read<SettingsCubit>().updateUserSelectedLeftSideSettingsListKey(kProfileKey);

                Navigator.pushReplacementNamed(context, splashRoute);
              } else if (state.status == BlocStatus.error) {
                if (state.authMessage != '') {
                  showSnackBar(context, state.authMessage);
                }
              }
            },
            buildWhen:
                (previous, current) =>
                    previous.status != current.status || previous.passwordUpdateStatus != current.passwordUpdateStatus,
            builder: (context, authState) {
              final isAuthLoading =
                  authState.status == BlocStatus.loading || authState.passwordUpdateStatus == BlocStatus.loading;

              return BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen:
                    (previous, current) =>
                        previous.userSelectedLeftSideSettingsListKey != current.userSelectedLeftSideSettingsListKey,
                builder: (context, state) {
                  return PopScope(
                    canPop: !isAuthLoading,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.arrow_back_ios_new,
                            size: 12.0,
                          ),
                          title: Text(
                            context.loc.goBack,
                            style: TextStyle(fontSize: 13.0),
                          ),
                          onTap: () => isAuthLoading ? () {} : _onClickGoBackButton(context),
                          hoverColor: Colors.transparent,
                          iconColor: isDarkMode ? kDarkContentColor : kLightContentColor,
                          textColor: isDarkMode ? kDarkContentColor : kLightContentColor,
                        ),
                        const Divider(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: listOfSettings(context).length,
                            itemBuilder: (context, index) {
                              final item = listOfSettings(context)[index];
                              final itemKey = item.key;
                              final isSelected = state.userSelectedLeftSideSettingsListKey == itemKey;

                              return Padding(
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
                                    onClickFunction: () => isAuthLoading ? () {} : _onClickTileButton(context, itemKey),
                                    valueKey: ValueKey(itemKey),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: LeftSideListTileWidget(
                            icon: Icons.logout_outlined,
                            title: context.loc.logOut,
                            onClickFunction: () => isAuthLoading ? () {} : _onClickLogOutButton(context),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _onClickTileButton(BuildContext context, String key) {
    context.read<SettingsCubit>().updateUserSelectedLeftSideSettingsListKey(key);
  }

  void _onClickGoBackButton(BuildContext context) {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _onClickLogOutButton(BuildContext context) async {
    final isDarkMode = checkIsDarkMode(context, context.read<ThemeCubit>().state.themeMode);

    final shouldLogOut = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            backgroundColor: isDarkMode ? kDarkCardBackgroundColor : kWhiteColor,
            title: Text(context.loc.confirmLogOut),
            content: Text(context.loc.logOutConfirmMessage),
            actions: [
              FormButtonWidget(
                onClickFunction: () => Navigator.of(ctx).pop(false),
                title: context.loc.cancel,
                isOutLineButton: true,
                fontSize: 11.0,
              ),

              FormButtonWidget(
                onClickFunction: () => Navigator.of(ctx).pop(true),
                title: context.loc.logOut,
                fontSize: 11.0,
              ),
            ],
          ),
    );

    if (shouldLogOut == true) {
      // ignore: use_build_context_synchronously
      context.read<AuthBloc>().add(UserLogOutButtonClick());
    }
  }
}
