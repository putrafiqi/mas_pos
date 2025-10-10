part of 'login_bloc.dart';

final class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginPressed(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
