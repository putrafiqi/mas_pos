import 'package:mas_pos/data/data.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  const AuthRepository(this._authRemoteDataSource);

  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authRemoteDataSource.login(
        email: email,
        password: password,
      );
      return right(user);
    } on AuthException catch (e) {
      return left(e.message);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> logout() async => await _authRemoteDataSource.logout();

  Future<UserModel> getCurrentUser() async {
    return await _authRemoteDataSource.getCurrentUser();
  }
}
