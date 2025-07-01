part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class UserSignUpWithEmailAndPasswordButtonClick extends AuthEvent {
  final String email;
  final String password;

  const UserSignUpWithEmailAndPasswordButtonClick({required this.email, required this.password});
}

class UserSignInWithEmailAndPasswordButtonClick extends AuthEvent {
  final String email;
  final String password;

  const UserSignInWithEmailAndPasswordButtonClick({required this.email, required this.password});
}

class CheckUserLogInOrNot extends AuthEvent {}

class UserLogOutButtonClick extends AuthEvent {}

class UserPasswordUpdateButtonClick extends AuthEvent {
  final String password;

  const UserPasswordUpdateButtonClick({required this.password});
}
