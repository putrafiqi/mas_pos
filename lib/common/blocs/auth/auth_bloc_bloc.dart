import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos/data/data.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthState.unknown()) {
    on<AuthChangeRequested>((event, emit) async {
      final user = await _authRepository.getCurrentUser();
      if (user != UserModel.empty) {
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unauthenticated());
      }
    });

    on<AuthLogoutPressed>((event, emit) async {
      await _authRepository.logout();
      emit(AuthState.unauthenticated());
    });
  }
}
