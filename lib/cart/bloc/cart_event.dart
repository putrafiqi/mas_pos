part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {
  const CartStarted();
}

class CartItemAdded extends CartEvent {
  final ProductModel product;

  const CartItemAdded(this.product);

  @override
  List<Object> get props => [product];
}

class CartItemRemoved extends CartEvent {
  final CartItemModel cartItem;

  const CartItemRemoved(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}

class CartItemDeleted extends CartEvent {
  final CartItemModel cartItem;

  const CartItemDeleted(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}

class PaymentMethodChanged extends CartEvent {
  final PaymentMethod paymentMethod;

  const PaymentMethodChanged(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

class ClearCartItem extends CartEvent {}
