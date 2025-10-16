part of 'product_bloc.dart';

enum ProductStatus { initial, loading, loaded, failure }

final class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductModel> allProductList;
  final String selectedCategoryId;
  final String searchQuery;
  final List<ProductModel> filteredProductList;
  final String? errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.selectedCategoryId = 'Semua',
    this.searchQuery = '',
    this.allProductList = const [],
    this.filteredProductList = const [],
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? allProductList,
    String? selectedCategoryId,
    String? searchQuery,
    List<ProductModel>? filteredProductList,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      allProductList: allProductList ?? this.allProductList,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredProductList: filteredProductList ?? this.filteredProductList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    allProductList,
    selectedCategoryId,
    searchQuery,
    filteredProductList,
  ];
}
