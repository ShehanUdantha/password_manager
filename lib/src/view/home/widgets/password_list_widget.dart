import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pass_key/src/blocs/auth/auth_bloc.dart';
import 'package:pass_key/src/blocs/password/password_bloc.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/services/encryption_service.dart';
import 'package:pass_key/src/core/utils/enums.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/core/widgets/text_form_field_widget.dart';
import 'package:pass_key/src/models/password_model.dart';
import 'package:pass_key/src/view/home/widgets/password_tile_widget.dart';

class PasswordListWidget extends StatefulWidget {
  const PasswordListWidget({super.key});

  @override
  State<PasswordListWidget> createState() => _PasswordListWidgetState();
}

class _PasswordListWidgetState extends State<PasswordListWidget> {
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  @override
  void initState() {
    _passwordListInit();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<PasswordBloc, PasswordState>(
        listenWhen: (previous, current) => previous.listStatus != current.listStatus,
        listener: (context, state) {
          if (state.listStatus == BlocStatus.error) {
            if (state.passwordMessage != '') {
              showSnackBar(context, state.passwordMessage);
            }
          }
        },
        buildWhen:
            (previous, current) =>
                previous.listStatus != current.listStatus ||
                previous.status != current.status ||
                previous.userSelectedPasswordModel != current.userSelectedPasswordModel,
        builder: (context, state) {
          final isListLoading = state.listStatus == BlocStatus.loading;
          final isLoading = state.status == BlocStatus.loading;

          return Column(
            children: [
              BlocListener<PasswordBloc, PasswordState>(
                listenWhen:
                    (previous, current) =>
                        previous.userSelectedLeftSideCategoryListKey != current.userSelectedLeftSideCategoryListKey,
                listener: (context, state) {
                  _onClearSearchValue();
                },
                child: TextFormFieldWidget(
                  controller: _searchController,
                  hintText: context.loc.search,
                  paddingVertical: 10.0,
                  isRequired: false,
                  onChangeFunction: (value) => _onChangeSearchValues(value),
                ),
              ),
              SizedBox(
                height: height * 0.018,
              ),
              isListLoading
                  ? SizedBox(
                    height: 20.0,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballPulseSync,
                      colors: [kAppGreenColor],
                      backgroundColor: Colors.transparent,
                      pathBackgroundColor: Colors.transparent,
                    ),
                  )
                  : Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: ListView.separated(
                        itemCount: state.lisOfPasswords.length,
                        itemBuilder: (_, index) {
                          final item = state.lisOfPasswords[index];

                          final isUserSelectedModel = state.userSelectedPasswordModel?.id == item.id;

                          final decryptedUserName = EncryptionService.decryptText(item.userName ?? "");

                          return PasswordTileWidget(
                            title: item.label ?? "",
                            subtitle: decryptedUserName,
                            isSelected: isUserSelectedModel,
                            isFavorite: item.isFavorite ?? false,
                            onClickFunction: () => isLoading ? () {} : _onClickPasswordTile(item),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }

  void _passwordListInit() {
    if (mounted) {
      context.read<PasswordBloc>().add(
        InitAllUsersPasswordsList(
          uid: context.read<AuthBloc>().state.userModel?.id,
        ),
      );
    }
  }

  void _onChangeSearchValues(String? value) {
    // cancel timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // start new timer
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        context.read<PasswordBloc>().add(
          GetUserPasswordsList(
            query: _searchController.text.trim(),
            uid: context.read<AuthBloc>().state.userModel?.id,
          ),
        );
      },
    );
  }

  void _onClearSearchValue() {
    _searchController.clear();
  }

  void _onClickPasswordTile(PasswordModel passwordModel) {
    context.read<PasswordBloc>().add(UpdateEditMode(value: false));
    context.read<PasswordBloc>().add(UpdateUserSelectedPasswordModel(passwordModel: passwordModel));
  }
}
