part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

final class GetAllCategory extends CategoryEvent {}

final class DeleteCategory extends CategoryEvent {
  final String id;

  const DeleteCategory(this.id);

  @override
  List<Object> get props => [id];
}

final class UpdateCategory extends CategoryEvent {
  final String id;
  final String name;

  const UpdateCategory(this.id, this.name);

  @override
  List<Object> get props => [];
}

final class AddCategory extends CategoryEvent {
  final String name;

  const AddCategory(this.name);

  @override
  List<Object> get props => [name];
}
