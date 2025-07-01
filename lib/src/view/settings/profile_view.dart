import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/auth/auth_bloc.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/constants/default_values.dart';
import 'package:pass_key/src/core/utils/enums.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/core/widgets/form_button_widget.dart';
import 'package:pass_key/src/core/widgets/text_form_field_widget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late GlobalKey<FormState> _formKey;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _keyboardFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _buttonFocus = FocusNode();

  bool _shouldShowUpdateButtons = false;
  bool _shouldShowClearButtons = false;

  @override
  void initState() {
    _initProfile();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _keyboardFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _buttonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.profile,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Text(
              context.loc.emailAddress,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: kMediumGreyColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            TextFormFieldWidget(
              controller: _emailController,
              hintText: context.loc.email,
              isReadOnly: true,
              fontSize: 13.0,
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Text(
              context.loc.changePassword,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: height * 0.03,
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) => previous.passwordUpdateStatus != current.passwordUpdateStatus,
              listener: (context, state) {
                if (state.passwordUpdateStatus == BlocStatus.success) {
                  _onClickPasswordFormClearButton();
                } else if (state.passwordUpdateStatus == BlocStatus.error) {
                  if (state.authMessage != '') {
                    showSnackBar(context, state.authMessage);
                  }
                }
              },
              buildWhen: (previous, current) => previous.passwordUpdateStatus != current.passwordUpdateStatus,
              builder: (context, authState) {
                final isAuthLoading = authState.passwordUpdateStatus == BlocStatus.loading;

                return KeyboardListener(
                  focusNode: _keyboardFocus,
                  onKeyEvent: (key) => _handleKeyEvent(key, isAuthLoading),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormFieldWidget(
                          controller: _newPasswordController,
                          focusNode: _newPasswordFocus,
                          hintText: context.loc.newPassword,
                          isReadOnly: isAuthLoading,
                          isRequired: false,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        TextFormFieldWidget(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          hintText: context.loc.confirmPassword,
                          isReadOnly: isAuthLoading,
                          isRequired: false,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10.0,
                          children: [
                            if (_shouldShowClearButtons)
                              FormButtonWidget(
                                onClickFunction: () => isAuthLoading ? () {} : _onClickPasswordFormClearButton(),
                                title: context.loc.clear,
                                isOutLineButton: true,
                                focusNode: _buttonFocus,
                                fontSize: 13.0,
                              ),
                            if (_shouldShowUpdateButtons)
                              FormButtonWidget(
                                onClickFunction: () => _onClickPasswordUpdateButton(),
                                title: context.loc.update,
                                isLoading: isAuthLoading,
                                focusNode: _buttonFocus,
                                fontSize: 13.0,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _initProfile() {
    _formKey = GlobalKey<FormState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userModel = context.read<AuthBloc>().state.userModel;

      _emailController.text = userModel?.email ?? "";
    });

    _newPasswordController.addListener(_onPasswordFieldChanged);
    _confirmPasswordController.addListener(_onPasswordFieldChanged);
  }

  void _onPasswordFieldChanged() {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    final shouldShowUpdateButton =
        newPassword.length >= kUserPasswordLength && confirmPassword.length >= kUserPasswordLength;

    final shouldShowClearButton = newPassword.isNotEmpty || confirmPassword.isNotEmpty;

    if (_shouldShowUpdateButtons != shouldShowUpdateButton) {
      setState(() {
        _shouldShowUpdateButtons = shouldShowUpdateButton;
      });
    }

    if (_shouldShowClearButtons != shouldShowClearButton) {
      setState(() {
        _shouldShowClearButtons = shouldShowClearButton;
      });
    }
  }

  void _onClickPasswordUpdateButton() {
    if (_formKey.currentState!.validate()) {
      final newPassword = _newPasswordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (newPassword == confirmPassword) {
        context.read<AuthBloc>().add(UserPasswordUpdateButtonClick(password: newPassword));
      } else {
        showSnackBar(context, context.loc.confirmPasswordDoNotMatchMessage);
      }
    }
  }

  void _onClickPasswordFormClearButton() {
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    _newPasswordFocus.unfocus();
    _confirmPasswordFocus.unfocus();
  }

  void _handleKeyEvent(KeyEvent event, bool isLoading) {
    if (event is KeyDownEvent) {
      if (_newPasswordFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
          FocusScope.of(context).requestFocus(_confirmPasswordFocus);
        }
      } else if (_confirmPasswordFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          FocusScope.of(context).requestFocus(_newPasswordFocus);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
          FocusScope.of(context).requestFocus(_buttonFocus);
        }
      } else if (_buttonFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          FocusScope.of(context).requestFocus(_confirmPasswordFocus);
        } else if (event.logicalKey == LogicalKeyboardKey.enter && !isLoading) {
          _onClickPasswordUpdateButton();
        }
      }
    }
  }
}
