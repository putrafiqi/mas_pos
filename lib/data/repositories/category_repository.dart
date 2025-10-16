import 'package:mas_pos/data/data.dart';
import 'package:fpdart/fpdart.dart';

class CategoryRepository {
  final CatalogRemoteDataSource _catalogRemoteDataSource;

  const CategoryRepository(this._catalogRemoteDataSource);

  Future<Either<String, List<CategoryModel>>> getAllCategory() async {
    try {
      final data = await _catalogRemoteDataSource.getAllCategory();
      return right(data);
    } on CatalogException {
      return left('Gagal mengambil data kategori');
    } catch (e) {
      return left('Terjadi Kesalahan');
    }
  }

  Future<Either<String, Unit>> deleteCategory({required String id}) async {
    try {
      await _catalogRemoteDataSource.deleteCategory(id: id);
      return right(unit);
    } on CatalogException {
      return left('Gagal menghapus kategori');
    } catch (e) {
      return left('Terjadi Kesalahan');
    }
  }

  Future<Either<String, Unit>> updateCategory({
    required String id,
    required String name,
  }) async {
    try {
      await _catalogRemoteDataSource.updateCategory(id: id, name: name);
      return right(unit);
    } on CatalogException {
      return left('Gagal mengupdate kategori');
    } catch (e) {
      return left('Terjadi Kesalahan');
    }
  }

  Future<Either<String, Unit>> addCategory({required String name}) async {
    try {
      await _catalogRemoteDataSource.addCategory(name: name);
      return right(unit);
    } on CatalogException {
      return left('Gagal menambahkan kategori');
    } catch (e) {
      return left('Terjadi Kesalahan');
    }
  }
}
