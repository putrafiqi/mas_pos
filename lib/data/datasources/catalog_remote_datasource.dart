import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mas_pos/data/data.dart';

class CatalogException implements Exception {
  final String message;

  const CatalogException({this.message = 'Terjadi Kesalahan'});

  @override
  String toString() {
    return 'CatalogException(message = $message)';
  }
}

abstract class CatalogRemoteDataSource {
  Future<List<ProductModel>> getAllProduct();

  Future<void> addProduct({
    required String name,
    required double price,
    required String categoryId,
    required File picture,
  });

  Future<void> updateProduct({
    required String id,
    required String name,
    required double price,
    required String categoryId,
    File? picture,
  });
  Future<void> deleteProduct({required String id});

  Future<List<CategoryModel>> getAllCategory();
  Future<void> addCategory({required String name});
  Future<void> updateCategory({required String id, required String name});
  Future<void> deleteCategory({required String id});
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final http.Client _client;
  final FlutterSecureStorage _storage;

  final String baseUrl = 'https://mas-pos.appmedia.id/api/v1';

  CatalogRemoteDataSourceImpl({
    http.Client? client,
    required FlutterSecureStorage storage,
  }) : _client = client ?? http.Client(),
       _storage = storage;

  @override
  Future<void> deleteCategory({required String id}) async {
    final url = Uri.parse('$baseUrl/category/$id');
    final token = await _storage.read(key: 'token');

    if (token == null) {
      throw CatalogException();
    }

    final response = await _client.delete(
      url,
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw CatalogException();
    }
  }

  @override
  Future<void> deleteProduct({required String id}) async {
    final url = Uri.parse('$baseUrl/product/$id');
    final token = await _storage.read(key: 'token');

    if (token == null) {
      throw CatalogException();
    }

    final response = await _client.delete(
      url,
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw CatalogException();
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategory() async {
    final url = Uri.parse('$baseUrl/category');
    final token = await _storage.read(key: 'token');

    if (token == null) {
      throw CatalogException();
    }

    final response = await _client.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw CatalogException();
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final data = responseBody['data'] as List<dynamic>;
    return data
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getAllProduct() async {
    final url = Uri.parse('$baseUrl/product');
    final token = await _storage.read(key: 'token');

    if (token == null) {
      throw CatalogException();
    }

    final response = await _client.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw CatalogException();
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final data = responseBody['data'] as List<dynamic>;
    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateCategory({
    required String id,
    required String name,
  }) async {
    final url = Uri.parse('$baseUrl/category/$id');
    final token = await _storage.read(key: 'token');

    if (token == null) {
      throw CatalogException();
    }

    final response = await _client.put(
      url,
      headers: <String, String>{'Authorization': 'Bearer $token'},
      body: <String, String>{'name': name},
    );

    if (response.statusCode != 200) {
      throw CatalogException();
    }
  }

  @override
  Future<void> updateProduct({
    required String id,
    required String name,
    required double price,
    required String categoryId,
    File? picture,
  }) async {
    final url = Uri.parse('$baseUrl/product/update/$id');
    final token = await _storage.read(key: 'token');

    if (token == null) throw CatalogException();

    final request = http.MultipartRequest('POST', url);

    if (picture != null) {
      final multiPartFile = await http.MultipartFile.fromPath(
        'picture',
        picture.path,
      );

      request.files.add(multiPartFile);
    }

    request.fields['name'] = name;
    request.fields['price'] = price.toInt().toString();
    request.fields['category_id'] = categoryId;
    request.headers['Authorization'] = 'Bearer $token';

    final responseStream = await request.send();
    final response = await http.Response.fromStream(responseStream);

    if (response.statusCode != 200) {
      throw CatalogException();
    }
  }

  @override
  Future<void> addCategory({required String name}) async {
    final url = Uri.parse('$baseUrl/category');
    final token = await _storage.read(key: 'token');

    if (token == null) throw CatalogException();

    final response = await _client.post(
      url,
      headers: <String, String>{'Authorization': 'Bearer $token'},
      body: <String, String>{'name': name},
    );

    if (response.statusCode != 200) {
      throw CatalogException();
    }
  }

  @override
  Future<void> addProduct({
    required String name,
    required double price,
    required String categoryId,
    required File picture,
  }) async {
    final url = Uri.parse('$baseUrl/product');
    final token = await _storage.read(key: 'token');

    if (token == null) throw CatalogException();

    final request = http.MultipartRequest('POST', url);

    final multiPartFile = await http.MultipartFile.fromPath(
      'picture',
      picture.path,
    );

    request.files.add(multiPartFile);
    request.fields['name'] = name;
    request.fields['price'] = price.toInt().toString();
    request.fields['category_id'] = categoryId;
    request.headers['Authorization'] = 'Bearer $token';

    final responseStream = await request.send();
    final response = await http.Response.fromStream(responseStream);

    if (response.statusCode != 200) {
      throw CatalogException();
    }
  }
}
