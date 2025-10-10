import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos/data/data.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  LoginBloc(this._authRepository) : super(LoginState()) {
    on<LoginPressed>((event, emit) async {
      emit(state.copyWith(status: LoginStatus.loading));
      final response = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      response.fold(
        (l) =>
            emit(state.copyWith(status: LoginStatus.failure, errorMessage: l)),
        (r) => emit(state.copyWith(status: LoginStatus.success, user: r)),
      );
    });
  }
}
