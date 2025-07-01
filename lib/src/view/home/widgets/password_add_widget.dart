import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/core/services/encryption_service.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/core/widgets/form_button_widget.dart';
import 'package:pass_key/src/models/password_category_model.dart';
import 'package:pass_key/src/view/home/widgets/password_category_choice_chip_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:pass_key/src/blocs/auth/auth_bloc.dart';
import 'package:pass_key/src/blocs/password/password_bloc.dart';
import 'package:pass_key/src/core/constants/keys.dart';
import 'package:pass_key/src/core/constants/lists.dart';
import 'package:pass_key/src/core/utils/enums.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/core/widgets/text_form_field_widget.dart';
import 'package:pass_key/src/models/password_model.dart';

class PasswordAddWidget extends StatefulWidget {
  final void Function(PasswordModel passwordModel) onSave;

  const PasswordAddWidget({
    super.key,
    required this.onSave,
  });

  @override
  State<PasswordAddWidget> createState() => _PasswordAddWidgetState();
}

class _PasswordAddWidgetState extends State<PasswordAddWidget> {
  late GlobalKey<FormState> _formKey;

  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _selectedCategory = kEmailKey;

  final FocusNode _keyboardFocus = FocusNode();
  final FocusNode _labelFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _notesFocus = FocusNode();
  final FocusNode _buttonFocus = FocusNode();

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _labelFocus.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    _keyboardFocus.dispose();
    _labelFocus.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _notesFocus.dispose();
    _buttonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: BlocConsumer<PasswordBloc, PasswordState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == BlocStatus.success) {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          } else if (state.status == BlocStatus.error) {
            if (state.passwordMessage != '') {
              showSnackBar(context, state.passwordMessage);
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.loc.newPassword,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  TextFormFieldWidget(
                    controller: _labelController,
                    hintText: context.loc.websiteOrLabel,
                    focusNode: _labelFocus,
                    isReadOnly: isLoading,
                    fontSize: 13.0,
                  ),
                  SizedBox(
                    height: height * 0.027,
                  ),
                  TextFormFieldWidget(
                    controller: _usernameController,
                    hintText: context.loc.userName,
                    focusNode: _usernameFocus,
                    isReadOnly: isLoading,
                    fontSize: 13.0,
                  ),
                  SizedBox(
                    height: height * 0.027,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormFieldWidget(
                          controller: _passwordController,
                          isPassword: false,
                          hintText: context.loc.password,
                          focusNode: _passwordFocus,
                          isReadOnly: isLoading,
                          fontSize: 13.0,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.auto_awesome,
                          size: 20.0,
                        ),
                        tooltip: context.loc.generatePassword,
                        onPressed: () => isLoading ? () {} : _onClickGeneratePasswordButton(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.027,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 35.0,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: listOfCategories(context).length,
                            itemBuilder: (context, index) {
                              final item = listOfCategories(context)[index];
                              final isSelected = _selectedCategory == item.key;
                              return PasswordCategoryChoiceChipWidget(
                                label: item.label,
                                isSelected: isSelected,
                                onSelectFunction: () => isLoading ? () {} : _onSelectChoiceChip(item),
                              );
                            },
                            separatorBuilder:
                                (context, index) => const SizedBox(
                                  width: 10.0,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  TextFormFieldWidget(
                    controller: _notesController,
                    maxLines: 3,
                    hintText: context.loc.addNotes,
                    focusNode: _notesFocus,
                    isReadOnly: isLoading,
                    isRequired: false,
                    fontSize: 13.0,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 10.0,
                    children: [
                      FormButtonWidget(
                        onClickFunction: () => isLoading ? () {} : _onClickPasswordAddDialogCloseButton(),
                        title: context.loc.cancel,
                        isOutLineButton: true,
                        focusNode: _buttonFocus,
                        fontSize: 13.0,
                      ),
                      FormButtonWidget(
                        onClickFunction: () => _onClickPasswordAddButton(),
                        title: context.loc.save,
                        isLoading: isLoading,
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
    );
  }

  void _onClickGeneratePasswordButton() {
    _passwordController.text = generatePassword();
  }

  void _onSelectChoiceChip(PasswordCategoryModel item) {
    if (_selectedCategory != item.key) {
      setState(() {
        _selectedCategory = item.key;
      });
    }
  }

  void _onClickPasswordAddButton() {
    if (_formKey.currentState!.validate()) {
      final uuid = Uuid();

      final encryptedUserName = EncryptionService.encryptText(_usernameController.text);
      final encryptedPassword = EncryptionService.encryptText(_passwordController.text);

      widget.onSave(
        PasswordModel(
          id: uuid.v4(),
          uid: context.read<AuthBloc>().state.userModel?.id,
          label: _labelController.text.trim(),
          userName: encryptedUserName,
          password: encryptedPassword,
          notes: _notesController.text.trim(),
          category: _selectedCategory,
          isFavorite: false,
          createdDate: DateTime.now(),
          updatedDate: DateTime.now(),
        ),
      );
    }
  }

  void _handleKeyEvent(KeyEvent event, bool isLoading) {
    if (event is KeyDownEvent) {
      if (_labelFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
          FocusScope.of(context).requestFocus(_usernameFocus);
        }
      } else if (_usernameFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          FocusScope.of(context).requestFocus(_labelFocus);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
          FocusScope.of(context).requestFocus(_passwordFocus);
        }
      } else if (_passwordFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          FocusScope.of(context).requestFocus(_usernameFocus);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
          FocusScope.of(context).requestFocus(_notesFocus);
        }
      } else if (_notesFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          FocusScope.of(context).requestFocus(_passwordFocus);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
          FocusScope.of(context).requestFocus(_buttonFocus);
        }
      } else if (_buttonFocus.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          FocusScope.of(context).requestFocus(_notesFocus);
        } else if (event.logicalKey == LogicalKeyboardKey.enter) {
          if (!isLoading) _onClickPasswordAddButton();
        }
      }
    }
  }

  void _onClickPasswordAddDialogCloseButton() {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
