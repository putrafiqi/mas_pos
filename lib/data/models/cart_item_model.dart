import 'package:equatable/equatable.dart';
import 'package:mas_pos/data/data.dart' show ProductModel;

class CartItemModel extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItemModel({required this.product, required this.quantity});

  CartItemModel copyWith({ProductModel? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}
