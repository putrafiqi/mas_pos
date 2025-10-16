import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mas_pos/cart/cart.dart';
import 'package:mas_pos/data/data.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartView();
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
      ),
      backgroundColor: Colors.grey.shade100,

      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.loading ||
              state.status == CartStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.cartList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.shopping_cart_copy,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Daftar pesanan masih kosong.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) => const Gap(8),
            padding: const EdgeInsets.all(8.0),
            itemCount: state.cartList.length + 1,
            itemBuilder: (context, index) {
              if (index == state.totalUniqueItems) {
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Metode Pembayaran', style: textTheme.titleMedium),
                      BlocSelector<CartBloc, CartState, PaymentMethod>(
                        selector: (state) {
                          return state.paymentMethod;
                        },
                        builder: (context, state) {
                          return TextButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                showDragHandle: true,
                                context: context,
                                builder:
                                    (_) => BlocProvider.value(
                                      value: context.read<CartBloc>(),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pilih Metode Pembayaran',
                                              style: textTheme.titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            RadioListTile(
                                              contentPadding: EdgeInsets.all(0),
                                              value: PaymentMethod.qris,
                                              title: Row(
                                                spacing: 16,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/qris_logo.png',
                                                  ),
                                                  const Text('QRIS'),
                                                ],
                                              ),
                                              groupValue: state,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  context.read<CartBloc>().add(
                                                    PaymentMethodChanged(value),
                                                  );
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                            RadioListTile(
                                              contentPadding: EdgeInsets.all(0),

                                              value: PaymentMethod.tunai,
                                              title: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                spacing: 16,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/tunai_logo.png',
                                                  ),
                                                  const Text('Tunai'),
                                                ],
                                              ),

                                              groupValue: state,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  context.read<CartBloc>().add(
                                                    PaymentMethodChanged(value),
                                                  );
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                            const Gap(16),
                                          ],
                                        ),
                                      ),
                                    ),
                              );
                            },
                            label:
                                state == PaymentMethod.qris
                                    ? Text('QRIS')
                                    : Text('Tunai'),
                            icon:
                                state == PaymentMethod.qris
                                    ? Image.asset('assets/images/qris_logo.png')
                                    : Image.asset(
                                      'assets/images/tunai_logo.png',
                                    ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              final cartItem = state.cartList[index];
              return _CartItemCard(cartItem: cartItem);
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.cartList.isNotEmpty) {
            return _CartSummary(
              totalPrice: state.totalPrice,
              paymentMethod: state.paymentMethod,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.cartItem});

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey.shade200,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(product.pictureUrl),
              ),
            ),
          ),
          const Gap(12),
          // Nama dan Harga
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),
          const Gap(12),
          QuantityCounter(
            initialValue: cartItem.quantity,
            onChanged: (value) {
              if (value > cartItem.quantity) {
                context.read<CartBloc>().add(CartItemAdded(product));
              } else {
                context.read<CartBloc>().add(CartItemRemoved(cartItem));
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.totalPrice, required this.paymentMethod});

  final double totalPrice;
  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Card(
      elevation: 4,

      margin: const EdgeInsets.all(0),
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    Text(
                      'Total Harga',
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.blue.shade800,
                      ),
                    ),
                    Text(
                      'Rp ${totalPrice.toStringAsFixed(0)}',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CheckoutPage(
                          totalPrice: totalPrice,
                          paymentMethod: paymentMethod,
                        ),
                  ),
                );
                context.read<CartBloc>().add(ClearCartItem());
              },
              child: const Text('Bayar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
