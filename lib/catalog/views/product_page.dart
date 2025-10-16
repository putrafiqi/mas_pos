import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mas_pos/catalog/catalog.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductView();
  }
}

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProductSearchField(),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 50,
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        if (index == 0) {
                          return BlocSelector<
                            ProductBloc,
                            ProductState,
                            String
                          >(
                            selector: (state) {
                              return state.selectedCategoryId;
                            },
                            builder: (context, state) {
                              return ChoiceChip(
                                disabledColor: Colors.transparent,

                                label: Text('Semua'),
                                onSelected: (value) {
                                  context.read<ProductBloc>().add(
                                    ChangeCategory('Semua'),
                                  );
                                },
                                selected: state == 'Semua',

                                side: BorderSide.none,
                                selectedColor: Colors.blue.shade100,

                                labelStyle: textTheme.labelLarge?.copyWith(
                                  color: Colors.blue.shade900,
                                ),
                                showCheckmark: false,
                              );
                            },
                          );
                        }
                        return BlocSelector<ProductBloc, ProductState, String>(
                          selector: (state) {
                            return state.selectedCategoryId;
                          },
                          builder: (context, state) {
                            return ChoiceChip(
                              disabledColor: Colors.transparent,

                              label: Text(category.name),
                              onSelected: (value) {
                                context.read<ProductBloc>().add(
                                  ChangeCategory(category.id),
                                );
                              },
                              selected: state == category.id,

                              side: BorderSide.none,
                              selectedColor: Colors.blue.shade100,

                              labelStyle: textTheme.labelLarge?.copyWith(
                                color: Colors.blue.shade900,
                              ),
                              showCheckmark: false,
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const Gap(4),
                      itemCount: state.categories.length,
                    );
                  },
                ),
              ),
            ),
            const Gap(16),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state.status == ProductStatus.loading) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 300,
                    ),
                    itemBuilder: (context, index) {
                      final product = state.filteredProductList[index];

                      return ProductCard(
                        product: product,
                        showCartButton: true,
                        showMenuButton: true,
                      );
                    },
                    itemCount: state.filteredProductList.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
