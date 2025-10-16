import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mas_pos/cart/cart.dart';
import 'package:mas_pos/data/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mas_pos/catalog/catalog.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.showCartButton = false,
    this.showMenuButton = false,
  });

  final bool showCartButton;
  final ProductModel product;
  final bool showMenuButton;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Container(
      width: 150,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(16),
          right: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: product.pictureUrl,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                    const Gap(4),
                    Text(
                      'Rp. ${product.price.toInt().toString()}',
                      style: textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (showMenuButton)
                MenuAnchor(
                  style: MenuStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                      (states) => Colors.white,
                    ),
                  ),
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isDismissible: false,
                          showDragHandle: true,
                          isScrollControlled: true,
                          context: context,
                          builder:
                              (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<ProductBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<CategoryBloc>(),
                                  ),
                                ],

                                child: FormEditProduct(product: product),
                              ),
                        );
                      },
                      leadingIcon: Icon(Iconsax.edit_copy, size: 20),
                      child: const Text('Edit'),
                    ),
                    MenuItemButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => BlocProvider.value(
                                value: context.read<ProductBloc>(),
                                child: AlertDialog(
                                  title: Text('Hapus Produk'),
                                  content: Text(
                                    'Apakah anda yakin ingin menghapus produk ini',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Tidak'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<ProductBloc>().add(
                                          DeleteProduct(product.id),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yakin'),
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                      leadingIcon: Icon(Iconsax.trash_copy, size: 20),
                      child: const Text('Delete'),
                    ),
                  ],
                  builder: (context, controller, child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: Icon(Icons.more_vert),
                    );
                  },
                ),
            ],
          ),
          const Gap(8),
          if (showCartButton)
            BlocBuilder<CartBloc, CartState>(
              buildWhen:
                  (previous, current) => previous.cartList != current.cartList,
              builder: (context, state) {
                if (state.isInCart(product)) {
                  final cartItem = state.cartList.firstWhere(
                    (item) => item.product == product,
                  );
                  return QuantityCounter(
                    initialValue: cartItem.quantity,
                    onChanged: (value) {
                      if (value > cartItem.quantity) {
                        context.read<CartBloc>().add(CartItemAdded(product));
                      } else {
                        context.read<CartBloc>().add(CartItemRemoved(cartItem));
                      }
                    },
                  );
                }
                return FilledButton.icon(
                  label: Text('Keranjang'),

                  onPressed: () {
                    context.read<CartBloc>().add(CartItemAdded(product));
                  },
                  icon: Icon(Icons.add),
                );
              },
            ),
        ],
      ),
    );
  }
}
