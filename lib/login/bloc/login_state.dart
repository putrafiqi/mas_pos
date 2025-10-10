part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

final class LoginState extends Equatable {
  final LoginStatus status;

  final String? errorMessage;
  final UserModel user;

  const LoginState({
    this.status = LoginStatus.initial,
    this.user = UserModel.empty,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    UserModel? user,
  }) => LoginState(
    status: status ?? this.status,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object> get props => [status, user];
}
