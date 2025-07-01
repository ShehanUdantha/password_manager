part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final BlocStatus status;
  final String authMessage;
  final UserModel? userModel;
  final BlocStatus passwordUpdateStatus;

  const AuthState({
    this.status = BlocStatus.initial,
    this.authMessage = '',
    this.userModel,
    this.passwordUpdateStatus = BlocStatus.initial,
  });

  AuthState copyWith({
    BlocStatus? status,
    String? authMessage,
    ValueGetter<UserModel?>? userModel,
    BlocStatus? passwordUpdateStatus,
  }) {
    return AuthState(
      status: status ?? this.status,
      authMessage: authMessage ?? this.authMessage,
      userModel: userModel != null ? userModel() : this.userModel,
      passwordUpdateStatus: passwordUpdateStatus ?? this.passwordUpdateStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    authMessage,
    userModel,
    passwordUpdateStatus,
  ];
}
