import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mas_pos/common/common.dart';
import 'package:mas_pos/data/data.dart';
import 'package:mas_pos/home/home.dart';
import 'package:mas_pos/catalog/catalog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  ProductBloc(context.read<ProductRepository>())
                    ..add(GetAllProduct()),
        ),
        BlocProvider(
          create:
              (context) =>
                  CategoryBloc(context.read<CategoryRepository>())
                    ..add(GetAllCategory()),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'MASPOS',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.blue.shade800,
            letterSpacing: 2,
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: ProductSearchField(readOnly: true),
                  ),
                  const Gap(24),
                  CaroulselBenner(),
                  const Gap(24),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diminati pembeli',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const Gap(16),
                        SizedBox(
                          height: 225,
                          child: BlocBuilder<ProductBloc, ProductState>(
                            builder: (context, state) {
                              if (state.status == ProductStatus.loading) {
                                return Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              }

                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final product = state.allProductList[index];

                                  return ProductCard(product: product);
                                },
                                itemCount: state.allProductList.length,
                                separatorBuilder:
                                    (context, index) => const Gap(16),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(16),

                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Produk yang dijual',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),

                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  selectedIndex = 1;
                                });
                              },
                              label: Text(
                                'Lihat Semua',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.blue.shade800,
                              ),
                              iconAlignment: IconAlignment.end,
                            ),
                          ],
                        ),
                        const Gap(16),
                        SizedBox(
                          height: 225,
                          child: BlocBuilder<ProductBloc, ProductState>(
                            builder: (context, state) {
                              if (state.status == ProductStatus.loading) {
                                return Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              }
                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final product = state.allProductList[index];
                                  return ProductCard(product: product);
                                },
                                itemCount: state.allProductList.length,
                                separatorBuilder:
                                    (context, index) => const Gap(16),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),

                  Text(
                    '-  MASPOS Versi 1.0  -',
                    textAlign: TextAlign.center,
                    style: textTheme.labelSmall,
                  ),
                  const Gap(16),
                ],
              ),
            ),
          ),
          ProductPage(),
          Center(
            child: FilledButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutPressed());
              },
              child: Text('Logout'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        backgroundColor: Colors.white,
        destinations: [
          NavigationDestination(icon: Icon(Iconsax.home_1_copy), label: 'Home'),
          NavigationDestination(
            icon: Icon(Iconsax.shopping_bag_copy),
            label: 'Produk',
          ),
          // NavigationDestination(
          //   icon: Icon(Iconsax.card_receive_copy),
          //   label: 'Transaksi',
          // ),
          NavigationDestination(icon: Icon(Iconsax.user_copy), label: 'Profil'),
        ],
      ),

      floatingActionButton:
          selectedIndex == 1
              ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    isDismissible: false,
                    showDragHandle: true,
                    context: context,
                    builder: (_) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<ProductBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<CategoryBloc>(),
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _ButtonCard(
                                titleText: 'Tambah Kategori',
                                supportText: 'Buat produkmu lebih rapi',
                                onTap: () {
                                  Navigator.pop(context);
                                  showModalBottomSheet(
                                    showDragHandle: true,
                                    isDismissible: false,
                                    context: context,
                                    builder:
                                        (_) => BlocProvider.value(
                                          value: context.read<CategoryBloc>(),
                                          child: FormAddCategory(),
                                        ),
                                  );
                                },
                              ),
                              _ButtonCard(
                                titleText: 'Tambah Produk',
                                supportText: 'Tambahin makanan atau minuman ',
                                onTap: () {
                                  Navigator.pop(context);
                                  showModalBottomSheet(
                                    isDismissible: false,
                                    showDragHandle: true,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (_) {
                                      return MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(
                                            value: context.read<ProductBloc>(),
                                          ),
                                          BlocProvider.value(
                                            value: context.read<CategoryBloc>(),
                                          ),
                                        ],
                                        child: FormAddProduct(),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },

                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF2C59E5),
                shape: CircleBorder(),
                child: Icon(Iconsax.add_copy),
              )
              : null,
    );
  }
}

class _ButtonCard extends StatelessWidget {
  const _ButtonCard({
    required this.titleText,
    required this.supportText,
    required this.onTap,
  });
  final String titleText;
  final String supportText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = TextTheme.of(context);

    return Flexible(
      child: Card(
        borderOnForeground: true,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(supportText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
