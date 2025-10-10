part of 'auth_bloc_bloc.dart';

final class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthChangeRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

final class AuthLogoutPressed extends AuthEvent {}
