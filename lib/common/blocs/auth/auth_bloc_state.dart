part of 'auth_bloc_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

final class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel user;

  const AuthState._({
    this.user = UserModel.empty,
    this.status = AuthStatus.unknown,
  });

  const AuthState.unknown() : this._();

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  const AuthState.authenticated(UserModel user)
    : this._(user: user, status: AuthStatus.authenticated);

  @override
  List<Object> get props => [user, status];
}
