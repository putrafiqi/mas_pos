part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, loaded, failure }

final class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<CategoryModel> categories;
  final String? errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.errorMessage,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryModel>? categories,
    String? errorMessage,
  }) => CategoryState(
    categories: categories ?? this.categories,
    status: status ?? this.status,
    errorMessage: errorMessage ?? errorMessage,
  );

  @override
  List<Object> get props => [status, categories];
}
