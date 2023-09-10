// ignore_for_file: unused_local_variable

import 'package:agritechv2/models/Products.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/utils/ProductProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toast/toast.dart';

import '../../blocs/product/product_bloc.dart';

import '../../repository/product_repository.dart';
import '../reusables/product_card.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> with TickerProviderStateMixin {
  late ProductProvider productProvider;
  late TabController _tabController;

  List<Widget> tabViews = [];

  void generateTabViews(List<String> categories) {
    for (String category in categories) {
      tabViews.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.5 / 4,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: productProvider.getProductsByCategory(category).length,
            itemBuilder: (context, index) {
              final Products product =
                  productProvider.getProductsByCategory(category)[index];
              return ProductCard(product);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ProductRepository(),
      child: BlocProvider(
        create: (context) =>
            ProductBloc(productRepository: context.read<ProductRepository>())
              ..add(GetProductEvent()),
        child: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              print(state.error);
            }
          },
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProductLoaded) {
              productProvider = ProductProvider(products: state.products);
              List<String> categories =
                  productProvider.getProductCategories().toList();
              print(
                  "controller ${productProvider.getProductCategories().length}");
              _tabController =
                  TabController(length: categories.length, vsync: this);
              generateTabViews(categories);

              return tabViews.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.go('/search');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                filled: true, // Add a white background
                                fillColor:
                                    Colors.white, // Set the fill color to white
                                contentPadding: EdgeInsets.all(8.0),
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder
                                    .none, // Remove the outline border
                              ),
                              child: Text(
                                'Search product here!',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                        TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          labelColor: ColorStyle.brandGreen,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: ColorStyle.brandGreen,
                          tabs: categories
                              .map((title) => Tab(text: title.toUpperCase()))
                              .toList(),
                        ),
                        Expanded(
                            child: TabBarView(
                          controller: _tabController,
                          children: tabViews,
                        )),
                      ],
                    );
            } else {
              return const Center(
                child: Text('No products available.'),
              );
            }
          },
        ),
      ),
    );
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }
}
