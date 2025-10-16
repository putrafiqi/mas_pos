import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mas_pos/catalog/catalog.dart';

class ProductSearchField extends StatelessWidget {
  const ProductSearchField({super.key, this.readOnly = false});

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        readOnly: readOnly,
        onChanged:
            (value) =>
                context.read<ProductBloc>().add(ChangeSearchQuery(value)),
        decoration: InputDecoration(
          prefixIcon: Icon(Iconsax.search_normal_1_copy, color: Colors.blue),
          hintText: 'Cari nama product',
          hintStyle: textTheme.bodyMedium,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
