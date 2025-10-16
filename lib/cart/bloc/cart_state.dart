part of 'cart_bloc.dart';

enum CartStatus { initial, loading, loaded, failure }

enum PaymentMethod { tunai, qris }

final class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemModel> cartList;
  final PaymentMethod paymentMethod;

  const CartState({
    this.status = CartStatus.initial,
    this.cartList = const [],
    this.paymentMethod = PaymentMethod.tunai,
  });

  int get totalUniqueItems => cartList.length;

  bool isInCart(ProductModel product) =>
      cartList.any((item) => item.product == product);

  double get totalPrice => cartList.fold(
    0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  CartState copyWith({
    CartStatus? status,
    List<CartItemModel>? cartList,
    PaymentMethod? paymentMethod,
  }) {
    return CartState(
      status: status ?? this.status,
      cartList: cartList ?? this.cartList,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object> get props => [status, cartList, paymentMethod];
}
