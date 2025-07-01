import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_key/src/core/utils/enums.dart';
import 'package:pass_key/src/models/user_model.dart';
import 'package:pass_key/src/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<UserSignUpWithEmailAndPasswordButtonClick>(onUserSignUpWithEmailAndPasswordButtonClick);
    on<UserSignInWithEmailAndPasswordButtonClick>(onUserSignInWithEmailAndPasswordButtonClick);
    on<CheckUserLogInOrNot>(onCheckUserLogInOrNot);
    on<UserLogOutButtonClick>(onUserLogOutButtonClick);
    on<UserPasswordUpdateButtonClick>(onUserPasswordUpdateButtonClick);
  }

  FutureOr<void> onUserSignUpWithEmailAndPasswordButtonClick(
    UserSignUpWithEmailAndPasswordButtonClick event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final response = await _authRepository.callSignUpWithEmailAndPassword(email: event.email, password: event.password);

    response.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          authMessage: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: BlocStatus.success,
          userModel: () => r,
        ),
      ),
    );
  }

  FutureOr<void> onUserSignInWithEmailAndPasswordButtonClick(
    UserSignInWithEmailAndPasswordButtonClick event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final response = await _authRepository.callSignInWithEmailAndPassword(email: event.email, password: event.password);

    response.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          authMessage: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: BlocStatus.success,
          userModel: () => r,
        ),
      ),
    );
  }

  FutureOr<void> onCheckUserLogInOrNot(
    CheckUserLogInOrNot event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final response = await _authRepository.callGetCurrentUserData();

    response.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          authMessage: l.message,
        ),
      ),
      (r) {
        if (r != null) {
          emit(
            state.copyWith(
              status: BlocStatus.success,
              userModel: () => r,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: BlocStatus.error,
              authMessage: '',
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onUserLogOutButtonClick(UserLogOutButtonClick event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final response = await _authRepository.callLogOutUser();

    response.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          authMessage: l.message,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
            userModel: () => null,
          ),
        );
      },
    );
  }

  FutureOr<void> onUserPasswordUpdateButtonClick(UserPasswordUpdateButtonClick event, Emitter<AuthState> emit) async {
    emit(state.copyWith(passwordUpdateStatus: BlocStatus.loading));

    final response = await _authRepository.callUpdateUserPassword(password: event.password);

    response.fold(
      (l) => emit(
        state.copyWith(
          passwordUpdateStatus: BlocStatus.error,
          authMessage: l.message,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            passwordUpdateStatus: BlocStatus.success,
          ),
        );
      },
    );
  }
}
