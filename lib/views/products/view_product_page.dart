import 'package:agritechv2/models/Products.dart';
import 'package:agritechv2/repository/product_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/styles/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../blocs/view_product_bloc/view_product_bloc.dart';

class ViewProductPage extends StatelessWidget {
  final String productID;
  const ViewProductPage({super.key, required this.productID});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ProductRepository(),
      child: BlocProvider(
        create: (context) => ViewProductBloc(
          productRepository: context.read<ProductRepository>(),
        )..add(GetProductByIDEvent(id: productID)),
        child: BlocConsumer<ViewProductBloc, ViewProductState>(
          listener: (context, state) {
            if (state is ViewProductError) {
              print(state.error.toString());
            }
          },
          builder: (context, state) {
            if (state is ViewProductLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ViewProductLoaded) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: ColorStyle.brandRed,
                  ),
                  body: ProductContainer(product: state.products));
            } else {
              return Center(
                child: Container(
                  child: const Text("Error Fetching Product.."),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ProductContainer extends StatefulWidget {
  final Products product;
  const ProductContainer({super.key, required this.product});

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: product.image != null
                        ? Image.network(
                            product.image!,
                            fit: BoxFit.fitHeight,
                          )
                        : const Icon(Icons.image),
                  ),
                  Text(
                    "${product.variations.length} variations available",
                    style: MyTextStyles.text,
                  ),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection:
                          Axis.horizontal, // Set scroll direction to horizontal
                      itemCount: product
                          .variations.length, // Number of items in the list
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          margin:
                              const EdgeInsets.all(5), // Margin between items
                          color: Colors.grey,
                          child: Center(
                            child: Text(
                              product.variations[index].name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: MyTextStyles.header,
                        ),
                        Text(
                          "₱ 1000",
                          style: MyTextStyles.text,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: 2.5,
                            itemCount: 5,
                            itemSize: 20.0,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "2.5",
                            style: MyTextStyles.textBold,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "100 sold",
                            style: MyTextStyles.textBold,
                          ),
                        ],
                      ),
                      const Icon(Icons.favorite_border_outlined),
                    ],
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          product.description,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Reviews",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "0",
                            ),
                          ],
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    // Add your button click logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Set background color to blue
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), // Set border radius to 0
                    ),
                  ),
                  child: const Text(
                    'Add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Add some spacing between buttons
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    // Add your button click logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Set background color to green
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), // Set border radius to 0
                    ),
                  ),
                  child: const Text(
                    'Buy now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
