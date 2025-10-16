import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final double price;
  final String pictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.pictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      pictureUrl: json['picture_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object> get props => [
    id,
    name,
    price,
    pictureUrl,
    categoryId,
    updatedAt,
    createdAt,
  ];
}
