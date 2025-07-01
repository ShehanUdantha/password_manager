import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/auth/auth_bloc.dart';
import 'package:pass_key/src/config/routes/route_names.dart';
import 'package:pass_key/src/core/utils/enums.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/core/widgets/form_button_widget.dart';
import 'package:pass_key/src/core/widgets/text_form_field_widget.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  late GlobalKey<FormState> _formKey;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _keyboardFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _buttonFocus = FocusNode();

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _keyboardFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _buttonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: width / 2,
              child: BlocConsumer<AuthBloc, AuthState>(
                listenWhen: (previous, current) => previous.status != current.status,
                listener: (context, state) {
                  if (state.status == BlocStatus.success) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      homeRoute,
                      (_) => false,
                    );
                  } else if (state.status == BlocStatus.error) {
                    if (state.authMessage != '') {
                      showSnackBar(context, state.authMessage);
                    }
                  }
                },
                buildWhen: (previous, current) => previous.status != current.status,
                builder: (context, state) {
                  final isLoading = state.status == BlocStatus.loading;

                  return KeyboardListener(
                    focusNode: _keyboardFocus,
                    onKeyEvent: (key) => _handleKeyEvent(key, isLoading),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            context.loc.welcomeBack,
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          TextFormFieldWidget(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            hintText: context.loc.email,
                            isReadOnly: isLoading,
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          TextFormFieldWidget(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            hintText: context.loc.password,
                            isPassword: true,
                            isReadOnly: isLoading,
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          FormButtonWidget(
                            onClickFunction: () => _onClickSignInButton(),
                            title: context.loc.logIn,
                            isLoading: isLoading,
                            focusNode: _buttonFocus,
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                text: '${context.loc.dontHaveAnAccount} ',
                                style: TextStyle(
                                  fontSize: 13.0,
                                ),
                                children: [
                                  TextSpan(
                                    text: context.loc.signUp,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () => isLoading ? () {} : _onClickSignUpButton(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onClickSignInButton() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        UserSignInWithEmailAndPasswordButtonClick(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  void _handleKeyEvent(KeyEvent event, bool isLoading) {
    if (event is KeyDownEvent) {
      if (_emailFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
          FocusScope.of(context).requestFocus(_passwordFocus);
        }
      } else if (_passwordFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          FocusScope.of(context).requestFocus(_emailFocus);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
          FocusScope.of(context).requestFocus(_buttonFocus);
        }
      } else if (_buttonFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          FocusScope.of(context).requestFocus(_passwordFocus);
        } else if (event.logicalKey == LogicalKeyboardKey.enter) {
          if (!isLoading) _onClickSignInButton();
        }
      }
    }
  }

  void _onClickSignUpButton() {
    Navigator.pushNamed(context, signUpRoute);
  }
}
