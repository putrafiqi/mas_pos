import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos/data/data.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(const ProductState()) {
    on<GetAllProduct>((event, emit) async {
      emit(state.copyWith(status: ProductStatus.loading));
      final result = await _productRepository.getAllProduct();

      result.fold(
        (failure) {
          debugPrint(failure);
          emit(
            state.copyWith(
              status: ProductStatus.failure,
              errorMessage: failure,
            ),
          );
        },
        (products) => emit(
          state.copyWith(
            status: ProductStatus.loaded,
            allProductList: products,
            filteredProductList: _filterProducts(
              allProducts: products,
              categoryId: state.selectedCategoryId,
              query: state.searchQuery,
            ),
          ),
        ),
      );
    });

    on<AddProduct>((event, emit) async {
      emit(state.copyWith(status: ProductStatus.loading));
      final result = await _productRepository.addProduct(
        name: event.name,
        price: event.price,
        categoryId: event.categoryId,
        picture: event.picture,
      );

      result.fold(
        (failure) => emit(
          state.copyWith(status: ProductStatus.failure, errorMessage: failure),
        ),
        (_) => add(GetAllProduct()),
      );
    });

    on<UpdateProduct>((event, emit) async {
      emit(state.copyWith(status: ProductStatus.loading));
      debugPrint(event.picture?.path.toString());
      debugPrint('Hallo ${event.picture?.path}');
      final result = await _productRepository.updateProduct(
        id: event.id,
        name: event.name,
        price: event.price,
        categoryId: event.categoryId,
        picture: event.picture,
      );

      result.fold(
        (failure) => emit(
          state.copyWith(status: ProductStatus.failure, errorMessage: failure),
        ),
        (_) => add(GetAllProduct()),
      );
    });

    on<DeleteProduct>((event, emit) async {
      emit(state.copyWith(status: ProductStatus.loading));
      final result = await _productRepository.deleteProduct(id: event.id);

      result.fold(
        (failure) => emit(
          state.copyWith(status: ProductStatus.failure, errorMessage: failure),
        ),
        (_) => add(GetAllProduct()),
      );
    });

    on<ChangeCategory>((event, emit) {
      final filteredList = _filterProducts(
        allProducts: state.allProductList,
        categoryId: event.selectedCategoryId,
        query: state.searchQuery,
      );
      emit(
        state.copyWith(
          selectedCategoryId: event.selectedCategoryId,
          filteredProductList: filteredList,
        ),
      );
    });

    on<ChangeSearchQuery>((event, emit) {
      final filteredList = _filterProducts(
        allProducts: state.allProductList,
        categoryId: state.selectedCategoryId,
        query: event.searchQuery,
      );
      emit(
        state.copyWith(
          searchQuery: event.searchQuery,
          filteredProductList: filteredList,
        ),
      );
    });
  }

  List<ProductModel> _filterProducts({
    required List<ProductModel> allProducts,
    required String categoryId,
    required String query,
  }) {
    List<ProductModel> filteredByCategory = [];

    if (categoryId == 'Semua') {
      filteredByCategory = allProducts;
    } else {
      filteredByCategory =
          allProducts
              .where((product) => product.categoryId == categoryId)
              .toList();
    }

    if (query.isEmpty) {
      return filteredByCategory;
    } else {
      return filteredByCategory
          .where(
            (product) =>
                product.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }
}
