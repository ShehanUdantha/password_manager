import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/password/password_bloc.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/utils/enums.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/core/widgets/form_button_widget.dart';
import 'package:pass_key/src/models/password_model.dart';
import 'package:pass_key/src/view/home/widgets/password_add_widget.dart';
import 'package:pass_key/src/view/home/widgets/password_list_widget.dart';
import 'package:pass_key/src/view/home/widgets/password_manage_widget.dart';

class HomeRightSideView extends StatelessWidget {
  const HomeRightSideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previous, current) => previous.themeMode != current.themeMode,
        builder: (context, state) {
          final isDarkMode = checkIsDarkMode(context, state.themeMode);

          return Column(
            children: [
              Container(
                height: 49.0,
                color: isDarkMode ? kDarkDividerColor : kLightDividerColor,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 7.0,
                  horizontal: 8.0,
                ),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              child: BlocBuilder<PasswordBloc, PasswordState>(
                                buildWhen: (previous, current) => previous.listStatus != current.listStatus,
                                builder: (context, state) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${getCategoryLabelByKey(context, state.userSelectedLeftSideCategoryListKey)} ${context.loc.passwords} ",
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "${state.lisOfPasswords.length} ${context.loc.items}",
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            BlocBuilder<PasswordBloc, PasswordState>(
                              buildWhen: (previous, current) => previous.status != current.status,
                              builder: (context, state) {
                                final isLoading = state.status == BlocStatus.loading;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: InkWell(
                                    onTap: () => isLoading ? () {} : _showPasswordAddDialog(context),
                                    child: Icon(
                                      Icons.add,
                                      size: 22.0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 1.0,
                      ),
                      Expanded(
                        flex: 5,
                        child: BlocBuilder<PasswordBloc, PasswordState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.status != current.status ||
                                  previous.isEditMode != current.isEditMode ||
                                  previous.userSelectedPasswordModel != current.userSelectedPasswordModel ||
                                  previous.deleteStatus != current.deleteStatus,

                          builder: (context, state) {
                            final isLoading = state.status == BlocStatus.loading;

                            final isDeleting = state.deleteStatus == BlocStatus.loading;

                            final isEditMode = state.isEditMode;

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                spacing: 8.0,
                                children: [
                                  if (isEditMode)
                                    FormButtonWidget(
                                      onClickFunction: () => isLoading ? () {} : _onClickPasswordDeleteButton(context),
                                      title: context.loc.delete,
                                      isOutLineButton: true,
                                      fontSize: 11.0,
                                      isLoading: isDeleting,
                                    ),

                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      spacing: 8.0,
                                      children: [
                                        if (!isEditMode && state.userSelectedPasswordModel != null)
                                          FormButtonWidget(
                                            onClickFunction:
                                                () => isLoading ? () {} : _onClickPasswordEditButton(context),
                                            title: context.loc.edit,
                                            isOutLineButton: true,
                                            fontSize: 11.0,
                                          ),

                                        if (isEditMode)
                                          FormButtonWidget(
                                            onClickFunction:
                                                () => isLoading ? () {} : _onClickPasswordEditModeCancelButton(context),
                                            title: context.loc.cancel,
                                            isOutLineButton: true,
                                            fontSize: 11.0,
                                          ),
                                        if (isEditMode)
                                          FormButtonWidget(
                                            onClickFunction: () => _onClickPasswordUpdateButton(context),
                                            title: context.loc.save,
                                            fontSize: 11.0,
                                            isLoading: isLoading,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: const PasswordListWidget(),
                    ),
                    Container(
                      color: isDarkMode ? kDarkDividerColor : kLightDividerColor,
                      width: 1.0,
                    ),
                    Expanded(
                      flex: 5,
                      child: const PasswordManageWidget(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPasswordAddDialog(BuildContext context) {
    final isDarkMode = checkIsDarkMode(context, context.read<ThemeCubit>().state.themeMode);

    context.read<PasswordBloc>().add(UpdateEditMode(value: false));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: isDarkMode ? kDarkCardBackgroundColor : kWhiteColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 400.0,
              child: PasswordAddWidget(
                onSave: (PasswordModel passwordModel) {
                  context.read<PasswordBloc>().add(
                    PasswordAddButtonClick(passwordModel: passwordModel),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _onClickPasswordEditButton(BuildContext context) {
    context.read<PasswordBloc>().add(UpdateEditMode(value: true));
  }

  void _onClickPasswordEditModeCancelButton(BuildContext context) {
    context.read<PasswordBloc>().add(UpdateEditMode(value: false));
  }

  void _onClickPasswordUpdateButton(BuildContext context) {
    context.read<PasswordBloc>().add(PasswordUpdateSaveButtonClick(value: true));
  }

  Future<void> _onClickPasswordDeleteButton(BuildContext context) async {
    final isDarkMode = checkIsDarkMode(context, context.read<ThemeCubit>().state.themeMode);

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            backgroundColor: isDarkMode ? kDarkCardBackgroundColor : kWhiteColor,
            title: Text(context.loc.confirmDelete),
            content: Text(context.loc.passwordDeleteConfirmMessage),
            actions: [
              FormButtonWidget(
                onClickFunction: () => Navigator.of(ctx).pop(false),
                title: context.loc.cancel,
                isOutLineButton: true,
                fontSize: 11.0,
              ),

              FormButtonWidget(
                onClickFunction: () => Navigator.of(ctx).pop(true),
                title: context.loc.delete,
                fontSize: 11.0,
                customColor: kErrorColor,
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      // ignore: use_build_context_synchronously
      context.read<PasswordBloc>().add(PasswordDeleteButtonClick());
    }
  }
}
