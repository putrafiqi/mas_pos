import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mas_pos/data/data.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepository {
  final CatalogRemoteDataSource _catalogRemoteDataSource;

  const ProductRepository(this._catalogRemoteDataSource);

  Future<Either<String, List<ProductModel>>> getAllProduct() async {
    try {
      final data = await _catalogRemoteDataSource.getAllProduct();

      return right(data);
    } on CatalogException {
      return left('Gagal mengambil data produk');
    } catch (e) {
      debugPrint(e.toString());
      return left('Terjadi Kesalahan');
    }
  }

  Future<Either<String, Unit>> addProduct({
    required name,
    required double price,
    required String categoryId,
    required File picture,
  }) async {
    try {
      await _catalogRemoteDataSource.addProduct(
        name: name,
        price: price,
        categoryId: categoryId,
        picture: picture,
      );
      return right(unit);
    } on CatalogException {
      return left('Gagal menambah data produk');
    } catch (e) {
      return left('Terjadi Kesalahan');
    }
  }

  Future<Either<String, Unit>> updateProduct({
    required String id,
    required String name,
    required double price,
    required String categoryId,
    File? picture,
  }) async {
    try {
      await _catalogRemoteDataSource.updateProduct(
        id: id,
        name: name,
        price: price,
        categoryId: categoryId,
        picture: picture,
      );
      return right(unit);
    } on CatalogException {
      return left('Gagal mengupdate produk');
    } catch (e) {
      return left('Terjadi Kesalahan');
    }
  }

  Future<Either<String, Unit>> deleteProduct({required String id}) async {
    try {
      await _catalogRemoteDataSource.deleteProduct(id: id);
      return right(unit);
    } on CatalogException {
      return left('Gagal menghapus produk');
    } catch (e) {
      return left('Terjadi Kesalahan');
    }
  }
}
