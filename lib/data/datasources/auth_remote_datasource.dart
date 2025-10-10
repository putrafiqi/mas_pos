import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mas_pos/data/data.dart';
import 'package:http/http.dart' as http;

class AuthException implements Exception {
  final String message;

  const AuthException({this.message = 'Terjadi Kasalahan'});

  @override
  String toString() {
    return 'AuthException(message = $message)';
  }
}

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client _httpClient;
  final FlutterSecureStorage _storage;

  final _baseUrl = 'https://mas-pos.appmedia.id/api/v1';

  AuthRemoteDataSourceImpl({
    http.Client? httpClient,
    required FlutterSecureStorage storage,
  }) : _httpClient = httpClient ?? http.Client(),
       _storage = storage;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/login');
      final response = await _httpClient.post(
        url,
        body: <String, String>{"email": email, "password": password},
      );
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw AuthException(message: responseBody['message'] as String);
      }

      await _storage.write(
        key: 'token',
        value:
            (responseBody['data'] as Map<String, dynamic>)['token'] as String,
      );
      return UserModel.fromJson(responseBody['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      final url = Uri.parse('$_baseUrl/profile');
      final response = await _httpClient.post(
        url,
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        final userData = responseBody['data'] as Map<String, dynamic>;

        return UserModel.fromJson(userData);
      }
    }
    return UserModel.empty;
  }
}
