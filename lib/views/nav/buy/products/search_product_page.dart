import 'package:agritechv2/blocs/product/product_bloc.dart';
import 'package:agritechv2/models/product/Products.dart';
import 'package:agritechv2/repository/product_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchProductPage extends StatefulWidget {
  const SearchProductPage({super.key});

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Products> _products = [];

  @override
  void initState() {
    _products = context.read<ProductRepository>().PRODUCTS;
    print("PRODUCTS : ${_products.length}");
    super.initState();
  }

  void searching(String searchTerm) {
    setState(() {
      if (searchTerm == '') {
        _products = context.read<ProductRepository>().PRODUCTS;
      } else {
        _products = context
            .read<ProductRepository>()
            .PRODUCTS
            .where((product) =>
                product.name.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Product'),
        backgroundColor: ColorStyle.brandRed,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InputDecorator(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(8.0),
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  searching(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Search product here!',
                  hintStyle: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (BuildContext context, int index) {
              final product = _products[index];
              return ListTile(
                leading: Image.network(
                  product.images[0],
                  width: 100,
                ),
                title: Text(product.name),
                subtitle: Text(getEffectivePrice(product)),
                onTap: () {
                  context.go('/product/${product.id}');
                },
              );
            },
          )),
        ],
      ),
    );
  }
}

class ErrorProduct extends StatelessWidget {
  final String message;
  const ErrorProduct({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}

class ProductSearchData extends StatelessWidget {
  final List<Products> products;
  const ProductSearchData({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: Image.network(product.images[0]),
          title: Text(product.name),
          subtitle: Text(getEffectivePrice(product)),
          trailing: IconButton.filled(
              onPressed: () {}, icon: const Icon(Icons.favorite)),
        );
      },
    );
  }
}
