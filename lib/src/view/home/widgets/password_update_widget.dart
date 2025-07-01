import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/services/encryption_service.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/models/password_category_model.dart';
import 'package:pass_key/src/view/home/widgets/password_category_choice_chip_widget.dart';
import 'package:pass_key/src/blocs/password/password_bloc.dart';
import 'package:pass_key/src/core/constants/keys.dart';
import 'package:pass_key/src/core/constants/lists.dart';
import 'package:pass_key/src/core/utils/enums.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/core/widgets/text_form_field_widget.dart';
import 'package:pass_key/src/models/password_model.dart';

class PasswordUpdateWidget extends StatefulWidget {
  const PasswordUpdateWidget({super.key});

  @override
  State<PasswordUpdateWidget> createState() => _PasswordUpdateWidgetState();
}

class _PasswordUpdateWidgetState extends State<PasswordUpdateWidget> {
  late GlobalKey<FormState> _formKey;

  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _selectedCategory = kEmailKey;
  bool _isFavorite = false;

  final FocusNode _keyboardFocus = FocusNode();
  final FocusNode _labelFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _notesFocus = FocusNode();

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _initPasswordUpdate();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocListener<PasswordBloc, PasswordState>(
        listenWhen:
            (previous, current) =>
                previous.isUserClickSubmitButtonToUpdateModel != current.isUserClickSubmitButtonToUpdateModel,
        listener: (context, state) {
          if (state.isUserClickSubmitButtonToUpdateModel) {
            _onClickPasswordUpdateButton();
          }
        },
        child: BlocConsumer<PasswordBloc, PasswordState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == BlocStatus.error) {
              if (state.passwordMessage != '') {
                showSnackBar(context, state.passwordMessage);
              }
            }
          },
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            final isLoading = state.status == BlocStatus.loading;

            return SingleChildScrollView(
              child: KeyboardListener(
                focusNode: _keyboardFocus,
                onKeyEvent: (key) => _handleKeyEvent,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Tooltip(
                          message: _isFavorite ? context.loc.unFavorite : context.loc.addToFavorite,
                          child: InkWell(
                            overlayColor: WidgetStatePropertyAll(Colors.transparent),
                            onTap: () => _onClickFavoriteButton(),
                            child: Icon(
                              _isFavorite ? Icons.star : Icons.star_border_outlined,
                              color: _isFavorite ? kWarningColor : kMediumGreyColor,
                              size: 18.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.027,
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
                      TextFormFieldWidget(
                        controller: _passwordController,
                        isPassword: false,
                        hintText: context.loc.password,
                        focusNode: _passwordFocus,
                        isReadOnly: isLoading,
                        fontSize: 13.0,
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
                                separatorBuilder: (context, index) => const SizedBox(width: 10.0),
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _initPasswordUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _labelFocus.requestFocus();

      final userSelectedPasswordModel = context.read<PasswordBloc>().state.userSelectedPasswordModel;

      final decryptedUserName = EncryptionService.decryptText(userSelectedPasswordModel?.userName ?? "");
      final decryptedPassword = EncryptionService.decryptText(userSelectedPasswordModel?.password ?? "");

      _labelController.text = userSelectedPasswordModel?.label ?? "";
      _usernameController.text = decryptedUserName;
      _passwordController.text = decryptedPassword;
      _notesController.text = userSelectedPasswordModel?.notes ?? "";

      if (userSelectedPasswordModel?.category != kEmailKey) {
        setState(() {
          _selectedCategory = userSelectedPasswordModel?.category ?? kEmailKey;
        });
      }

      if (userSelectedPasswordModel?.isFavorite != false) {
        setState(() {
          _isFavorite = userSelectedPasswordModel?.isFavorite ?? false;
        });
      }
    });
  }

  void _onClickFavoriteButton() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _onSelectChoiceChip(PasswordCategoryModel item) {
    if (_selectedCategory != item.key) {
      setState(() {
        _selectedCategory = item.key;
      });
    }
  }

  void _onClickPasswordUpdateButton() {
    if (_formKey.currentState!.validate()) {
      final userSelectedModel = context.read<PasswordBloc>().state.userSelectedPasswordModel;

      final encryptedUserName = EncryptionService.encryptText(_usernameController.text);
      final encryptedPassword = EncryptionService.encryptText(_passwordController.text);

      final passwordModel = PasswordModel(
        id: userSelectedModel?.id,
        uid: userSelectedModel?.uid,
        label: _labelController.text.trim(),
        userName: encryptedUserName,
        password: encryptedPassword,
        notes: _notesController.text.trim(),
        category: _selectedCategory,
        isFavorite: _isFavorite,
        createdDate: userSelectedModel?.createdDate,
        updatedDate: DateTime.now(),
      );

      context.read<PasswordBloc>().add(
        PasswordUpdateButtonClick(
          passwordModel: passwordModel,
          isPreviouslyFavorite: userSelectedModel?.isFavorite ?? false,
        ),
      );
    }
  }

  void _handleKeyEvent(KeyEvent event) {
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
        }
      }
    }
  }
}
