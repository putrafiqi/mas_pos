part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

final class GetAllProduct extends ProductEvent {}

final class AddProduct extends ProductEvent {
  final String name;
  final double price;
  final String categoryId;
  final File picture;

  const AddProduct(this.name, this.categoryId, this.price, this.picture);

  @override
  List<Object> get props => [name, price, categoryId, picture];
}

final class DeleteProduct extends ProductEvent {
  final String id;

  const DeleteProduct(this.id);

  @override
  List<Object> get props => [id];
}

final class UpdateProduct extends ProductEvent {
  final String id;
  final String name;
  final double price;
  final String categoryId;
  final File? picture;

  const UpdateProduct(
    this.id,
    this.name,
    this.categoryId,
    this.price,
    this.picture,
  );

  @override
  List<Object> get props => [name, id, price, categoryId];
}

final class ChangeCategory extends ProductEvent {
  final String selectedCategoryId;

  const ChangeCategory(this.selectedCategoryId);

  @override
  List<Object> get props => [selectedCategoryId];
}

final class ChangeSearchQuery extends ProductEvent {
  final String searchQuery;

  const ChangeSearchQuery(this.searchQuery);

  @override
  List<Object> get props => [searchQuery];
}
