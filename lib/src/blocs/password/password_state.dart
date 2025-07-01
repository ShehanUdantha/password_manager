part of 'password_bloc.dart';

class PasswordState extends Equatable {
  final BlocStatus status;
  final String passwordMessage;
  final String userSelectedLeftSideCategoryListKey;
  final BlocStatus listStatus;
  final List<PasswordModel> lisOfPasswords;
  final PasswordModel? userSelectedPasswordModel;
  final bool isEditMode;
  final bool isUserClickSubmitButtonToUpdateModel;
  final BlocStatus deleteStatus;

  const PasswordState({
    this.status = BlocStatus.initial,
    this.listStatus = BlocStatus.initial,
    this.passwordMessage = '',
    this.userSelectedLeftSideCategoryListKey = kAllKey,
    this.lisOfPasswords = const [],
    this.userSelectedPasswordModel,
    this.isEditMode = false,
    this.isUserClickSubmitButtonToUpdateModel = false,
    this.deleteStatus = BlocStatus.initial,
  });

  PasswordState copyWith({
    BlocStatus? status,
    BlocStatus? listStatus,
    String? passwordMessage,
    String? userSelectedLeftSideCategoryListKey,
    List<PasswordModel>? lisOfPasswords,
    ValueGetter<PasswordModel?>? userSelectedPasswordModel,
    bool? isEditMode,
    bool? isUserClickSubmitButtonToUpdateModel,
    BlocStatus? deleteStatus,
  }) {
    return PasswordState(
      status: status ?? this.status,
      listStatus: listStatus ?? this.listStatus,
      passwordMessage: passwordMessage ?? this.passwordMessage,
      userSelectedLeftSideCategoryListKey:
          userSelectedLeftSideCategoryListKey ?? this.userSelectedLeftSideCategoryListKey,
      lisOfPasswords: lisOfPasswords ?? this.lisOfPasswords,
      userSelectedPasswordModel:
          userSelectedPasswordModel != null ? userSelectedPasswordModel() : this.userSelectedPasswordModel,
      isEditMode: isEditMode ?? this.isEditMode,
      isUserClickSubmitButtonToUpdateModel:
          isUserClickSubmitButtonToUpdateModel ?? this.isUserClickSubmitButtonToUpdateModel,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    listStatus,
    passwordMessage,
    userSelectedLeftSideCategoryListKey,
    lisOfPasswords,
    userSelectedPasswordModel,
    isEditMode,
    isUserClickSubmitButtonToUpdateModel,
    deleteStatus,
  ];
}
