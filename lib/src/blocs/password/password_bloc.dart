// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/core/constants/keys.dart';
import 'package:pass_key/src/core/errors/failure.dart';
import 'package:pass_key/src/core/utils/enums.dart';
import 'package:pass_key/src/models/password_model.dart';
import 'package:pass_key/src/repositories/password_repository.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final PasswordRepository _passwordRepository;
  PasswordBloc(
    this._passwordRepository,
  ) : super(const PasswordState()) {
    on<UpdateUserSelectedLeftSideCategoryListKey>(onUpdateUserSelectedLeftSideCategoryListKey);
    on<PasswordAddButtonClick>(onPasswordAddButtonClick);
    on<InitAllUsersPasswordsList>(onInitAllUsersPasswordsList);
    on<GetUserPasswordsList>(onGetUserPasswordsList);
    on<AddNewPasswordToList>(onAddNewPasswordToList);
    on<UpdateUserSelectedPasswordModel>(onUpdateUserSelectedPasswordModel);
    on<UpdateEditMode>(onUpdateEditMode);
    on<PasswordUpdateSaveButtonClick>(onPasswordUpdateSaveButtonClick);
    on<PasswordUpdateButtonClick>(onPasswordUpdateButtonClick);
    on<AddUpdatedPasswordToList>(onAddUpdatedPasswordToList);
    on<PasswordDeleteButtonClick>(onPasswordDeleteButtonClick);
    on<RemoveDeletedPasswordFromList>(onRemoveDeletedPasswordFromList);
    on<InitPasswordBloc>(onInitPasswordBloc);
  }

  FutureOr<void> onUpdateUserSelectedLeftSideCategoryListKey(
    UpdateUserSelectedLeftSideCategoryListKey event,
    Emitter<PasswordState> emit,
  ) {
    if (state.userSelectedLeftSideCategoryListKey != event.key) {
      emit(
        state.copyWith(userSelectedLeftSideCategoryListKey: event.key),
      );
      add(GetUserPasswordsList(uid: event.uid));
    }
  }

  FutureOr<void> onPasswordAddButtonClick(PasswordAddButtonClick event, Emitter<PasswordState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final response = await _passwordRepository.callAddPassword(passwordModel: event.passwordModel);

    response.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          passwordMessage: l.message,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );

        add(AddNewPasswordToList(passwordModel: r));
      },
    );
  }

  FutureOr<void> onInitAllUsersPasswordsList(InitAllUsersPasswordsList event, Emitter<PasswordState> emit) async {
    emit(
      state.copyWith(listStatus: BlocStatus.loading),
    );

    final response = await _passwordRepository.callGetAllPasswords(
      query: event.query ?? "",
      uid: event.uid ?? "-1",
    );

    response.fold(
      (l) => emit(
        state.copyWith(
          listStatus: BlocStatus.error,
          passwordMessage: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listStatus: BlocStatus.success,
          lisOfPasswords: r,
        ),
      ),
    );
  }

  FutureOr<void> onGetUserPasswordsList(GetUserPasswordsList event, Emitter<PasswordState> emit) async {
    emit(
      state.copyWith(listStatus: BlocStatus.loading),
    );

    late Either<Failure, List<PasswordModel>> response;

    switch (state.userSelectedLeftSideCategoryListKey) {
      case kAllKey:
        response = await _passwordRepository.callGetAllPasswords(
          query: event.query ?? "",
          uid: event.uid ?? "-1",
        );
        break;

      case kFavoritesKey:
        response = await _passwordRepository.callGetFavoritePasswords(
          query: event.query ?? "",
          uid: event.uid ?? "-1",
        );
        break;

      default:
        response = await _passwordRepository.callGetAllPasswordsByCategory(
          category: state.userSelectedLeftSideCategoryListKey,
          query: event.query ?? "",
          uid: event.uid ?? "-1",
        );
        break;
    }

    response.fold(
      (l) => emit(
        state.copyWith(
          listStatus: BlocStatus.error,
          passwordMessage: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listStatus: BlocStatus.success,
          lisOfPasswords: r,
        ),
      ),
    );
  }

  FutureOr<void> onAddNewPasswordToList(AddNewPasswordToList event, Emitter<PasswordState> emit) {
    final newModel = event.passwordModel;
    final selectedCategory = state.userSelectedLeftSideCategoryListKey;
    final isFavorite = newModel.isFavorite ?? false;

    final shouldAdd =
        selectedCategory == kAllKey ||
        selectedCategory == newModel.category ||
        (isFavorite && selectedCategory == kFavoritesKey);

    if (shouldAdd) {
      emit(
        state.copyWith(listStatus: BlocStatus.loading),
      );

      emit(
        state.copyWith(
          lisOfPasswords: [...state.lisOfPasswords, newModel],
          listStatus: BlocStatus.success,
        ),
      );
    }
  }

  FutureOr<void> onUpdateUserSelectedPasswordModel(
    UpdateUserSelectedPasswordModel event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      state.copyWith(
        userSelectedPasswordModel: () => event.passwordModel,
      ),
    );
  }

  FutureOr<void> onUpdateEditMode(UpdateEditMode event, Emitter<PasswordState> emit) {
    if (state.isEditMode != event.value) {
      emit(state.copyWith(isEditMode: event.value));
    }
  }

  FutureOr<void> onPasswordUpdateSaveButtonClick(
    PasswordUpdateSaveButtonClick event,
    Emitter<PasswordState> emit,
  ) {
    if (state.isUserClickSubmitButtonToUpdateModel != event.value) {
      emit(
        state.copyWith(
          isUserClickSubmitButtonToUpdateModel: event.value,
        ),
      );
    }
  }

  FutureOr<void> onPasswordUpdateButtonClick(PasswordUpdateButtonClick event, Emitter<PasswordState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final response = await _passwordRepository.callUpdatePassword(passwordModel: event.passwordModel);

    response.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          passwordMessage: l.message,
          isUserClickSubmitButtonToUpdateModel: false,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
            isUserClickSubmitButtonToUpdateModel: false,
            isEditMode: false,
            userSelectedPasswordModel: () => r,
          ),
        );

        add(
          AddUpdatedPasswordToList(
            passwordModel: r,
            isPreviouslyFavorite: event.isPreviouslyFavorite,
          ),
        );
      },
    );
  }

  FutureOr<void> onAddUpdatedPasswordToList(AddUpdatedPasswordToList event, Emitter<PasswordState> emit) {
    final updatedModel = event.passwordModel;
    final selectedCategory = state.userSelectedLeftSideCategoryListKey;
    final isCurrentlyFavoriteOrPreviouslyFavorite =
        (updatedModel.isFavorite ?? false) == false ? event.isPreviouslyFavorite : true;
    final isInFavoriteTab = (isCurrentlyFavoriteOrPreviouslyFavorite && selectedCategory == kFavoritesKey);

    final shouldUpdate = selectedCategory == kAllKey || selectedCategory == updatedModel.category || isInFavoriteTab;

    if (shouldUpdate) {
      emit(
        state.copyWith(listStatus: BlocStatus.loading),
      );

      final filteredList = state.lisOfPasswords.where((oldModel) => oldModel.id != updatedModel.id).toList();

      emit(
        state.copyWith(
          lisOfPasswords:
              isInFavoriteTab
                  ? (updatedModel.isFavorite ?? false)
                      ? [...filteredList, updatedModel]
                      : filteredList
                  : [...filteredList, updatedModel],
          listStatus: BlocStatus.success,
        ),
      );
    }
  }

  FutureOr<void> onPasswordDeleteButtonClick(PasswordDeleteButtonClick event, Emitter<PasswordState> emit) async {
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        deleteStatus: BlocStatus.loading,
      ),
    );

    final userSelectedPasswordModel = state.userSelectedPasswordModel;

    final response = await _passwordRepository.callDeletePassword(id: userSelectedPasswordModel?.id ?? "-1");

    response.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          deleteStatus: BlocStatus.error,
          passwordMessage: l.message,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
            deleteStatus: BlocStatus.success,
            isEditMode: false,
            userSelectedPasswordModel: () => null,
          ),
        );

        add(
          RemoveDeletedPasswordFromList(
            passwordModel: userSelectedPasswordModel,
          ),
        );
      },
    );
  }

  FutureOr<void> onRemoveDeletedPasswordFromList(RemoveDeletedPasswordFromList event, Emitter<PasswordState> emit) {
    final deletedModel = event.passwordModel;
    final selectedCategory = state.userSelectedLeftSideCategoryListKey;
    final isFavorite = deletedModel?.isFavorite ?? false;

    final shouldRemove =
        selectedCategory == kAllKey ||
        selectedCategory == deletedModel?.category ||
        (isFavorite && selectedCategory == kFavoritesKey);

    if (shouldRemove) {
      emit(
        state.copyWith(listStatus: BlocStatus.loading),
      );

      final filteredList = state.lisOfPasswords.where((model) => model.id != deletedModel?.id).toList();

      emit(
        state.copyWith(
          lisOfPasswords: filteredList,
          listStatus: BlocStatus.success,
        ),
      );
    }
  }

  FutureOr<void> onInitPasswordBloc(InitPasswordBloc event, Emitter<PasswordState> emit) {
    emit(
      state.copyWith(
        userSelectedLeftSideCategoryListKey: kAllKey,
        lisOfPasswords: [],
        userSelectedPasswordModel: () => null,
        isEditMode: false,
        isUserClickSubmitButtonToUpdateModel: false,
      ),
    );
  }
}
