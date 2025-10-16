import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos/data/data.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartStarted>(_onCartStarted);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartItemDeleted>(_onCartItemDeleted);
    on<PaymentMethodChanged>(_onPaymentMethodChanged);
    on<ClearCartItem>(_onClearCartItem);
  }

  void _onClearCartItem(ClearCartItem event, Emitter<CartState> emit) {
    emit(state.copyWith(cartList: [], status: CartStatus.loaded));
  }

  void _onCartStarted(CartStarted event, Emitter<CartState> emit) {
    emit(state.copyWith(status: CartStatus.loading));
    emit(state.copyWith(status: CartStatus.loaded, cartList: []));
  }

  void _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final currentState = state;
    emit(state.copyWith(status: CartStatus.loading));

    try {
      final List<CartItemModel> updatedCartList = List.from(
        currentState.cartList,
      );
      final int itemIndex = updatedCartList.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (itemIndex != -1) {
        final existingItem = updatedCartList[itemIndex];
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
        updatedCartList[itemIndex] = updatedItem;
      } else {
        updatedCartList.add(CartItemModel(product: event.product, quantity: 1));
      }

      emit(
        currentState.copyWith(
          status: CartStatus.loaded,
          cartList: updatedCartList,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(status: CartStatus.failure));
    }
  }

  void _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final currentState = state;
    emit(state.copyWith(status: CartStatus.loading));

    try {
      final List<CartItemModel> updatedCartList = List.from(
        currentState.cartList,
      );
      final int itemIndex = updatedCartList.indexWhere(
        (item) => item.product.id == event.cartItem.product.id,
      );

      if (itemIndex == -1) return;

      final existingItem = updatedCartList[itemIndex];

      if (existingItem.quantity > 1) {
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
        );
        updatedCartList[itemIndex] = updatedItem;
      } else {
        updatedCartList.removeAt(itemIndex);
      }

      emit(
        currentState.copyWith(
          status: CartStatus.loaded,
          cartList: updatedCartList,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(status: CartStatus.failure));
    }
  }

  void _onCartItemDeleted(CartItemDeleted event, Emitter<CartState> emit) {
    final currentState = state;
    emit(state.copyWith(status: CartStatus.loading));

    try {
      final List<CartItemModel> updatedCartList = List.from(
        currentState.cartList,
      );

      updatedCartList.removeWhere(
        (item) => item.product.id == event.cartItem.product.id,
      );

      emit(
        currentState.copyWith(
          status: CartStatus.loaded,
          cartList: updatedCartList,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(status: CartStatus.failure));
    }
  }

  void _onPaymentMethodChanged(
    PaymentMethodChanged event,
    Emitter<CartState> emit,
  ) {
    // Cukup emit state baru dengan metode pembayaran yang diperbarui
    emit(state.copyWith(paymentMethod: event.paymentMethod));
  }
}
