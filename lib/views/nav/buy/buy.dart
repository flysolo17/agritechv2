import 'package:agritechv2/repository/product_repository.dart';
import 'package:agritechv2/views/custom%20widgets/product_card.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/product/Products.dart';
import '../../../styles/color_styles.dart';
import '../../../utils/Constants.dart';

class BuyPage extends StatelessWidget {
  const BuyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Products>>(
      stream: context.read<ProductRepository>().getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.stackTrace}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buyLoadingPage();
        }
        if (snapshot.data != null) {
          var productsList = snapshot.data ?? [];
          if (productsList.isNotEmpty) {
            return ProductTabs(products: productsList);
          } else {
            return const Center(
              child: Text("No Products Yet!"),
            );
          }
        } else {
          return const Center(
            child: Text("Unknown error"),
          );
        }
      },
    );
  }
}

class ProductTabs extends StatefulWidget {
  final List<Products> products;

  const ProductTabs({Key? key, required this.products}) : super(key: key);

  @override
  _ProductTabsState createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    _tabController = TabController(
        length: productCategories(widget.products).length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = productCategories(widget.products);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
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
                      fillColor: Colors.white, // Set the fill color to white
                      contentPadding: EdgeInsets.all(8.0),
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none, // Remove the outline border
                    ),
                    child: Text(
                      'Search product here!',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  width: double.infinity, // Make it 100% width
                  color: Colors.white, // Set the background color to white
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    labelColor: ColorStyle.brandGreen,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: ColorStyle.brandGreen,
                    tabs: categories
                        .map((title) => Tab(text: title.toUpperCase()))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: categories.mapIndexed((index, category) {
              return ProductsPerCategory(
                products: filterProductsByCategory(widget.products, category),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ProductsPerCategory extends StatelessWidget {
  final List<Products> products;
  const ProductsPerCategory({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 8.0, // Horizontal gap between items
          mainAxisSpacing: 8.0,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product);
        },
      ),
    );
  }
}
