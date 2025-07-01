part of 'password_bloc.dart';

sealed class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserSelectedLeftSideCategoryListKey extends PasswordEvent {
  final String key;
  final String? uid;

  const UpdateUserSelectedLeftSideCategoryListKey({required this.key, required this.uid});
}

class PasswordAddButtonClick extends PasswordEvent {
  final PasswordModel passwordModel;

  const PasswordAddButtonClick({required this.passwordModel});
}

class InitAllUsersPasswordsList extends PasswordEvent {
  final String? query;
  final String? uid;

  const InitAllUsersPasswordsList({this.query, required this.uid});
}

class GetUserPasswordsList extends PasswordEvent {
  final String? query;
  final String? uid;

  const GetUserPasswordsList({this.query, required this.uid});
}

class AddNewPasswordToList extends PasswordEvent {
  final PasswordModel passwordModel;

  const AddNewPasswordToList({required this.passwordModel});
}

class UpdateUserSelectedPasswordModel extends PasswordEvent {
  final PasswordModel passwordModel;

  const UpdateUserSelectedPasswordModel({required this.passwordModel});
}

class UpdateEditMode extends PasswordEvent {
  final bool value;

  const UpdateEditMode({required this.value});
}

class PasswordUpdateSaveButtonClick extends PasswordEvent {
  final bool value;

  const PasswordUpdateSaveButtonClick({required this.value});
}

class PasswordUpdateButtonClick extends PasswordEvent {
  final bool isPreviouslyFavorite;
  final PasswordModel passwordModel;

  const PasswordUpdateButtonClick({
    required this.passwordModel,
    required this.isPreviouslyFavorite,
  });
}

class AddUpdatedPasswordToList extends PasswordEvent {
  final PasswordModel passwordModel;
  final bool isPreviouslyFavorite;

  const AddUpdatedPasswordToList({
    required this.passwordModel,
    required this.isPreviouslyFavorite,
  });
}

class PasswordDeleteButtonClick extends PasswordEvent {}

class RemoveDeletedPasswordFromList extends PasswordEvent {
  final PasswordModel? passwordModel;

  const RemoveDeletedPasswordFromList({
    required this.passwordModel,
  });
}

class InitPasswordBloc extends PasswordEvent {}
