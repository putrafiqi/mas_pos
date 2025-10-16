import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos/data/data.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc(this._categoryRepository) : super(CategoryState()) {
    on<GetAllCategory>((event, emit) async {
      emit(state.copyWith(status: CategoryStatus.loading));
      final data = await _categoryRepository.getAllCategory();

      data.fold(
        (message) => emit(
          state.copyWith(status: CategoryStatus.failure, errorMessage: message),
        ),
        (categories) => emit(
          state.copyWith(status: CategoryStatus.loaded, categories: categories),
        ),
      );
    });

    on<AddCategory>((event, emit) async {
      emit(state.copyWith(status: CategoryStatus.loading));
      final data = await _categoryRepository.addCategory(name: event.name);

      data.fold(
        (l) => emit(
          state.copyWith(status: CategoryStatus.failure, errorMessage: l),
        ),
        (_) => add(GetAllCategory()),
      );
    });
  }
}
