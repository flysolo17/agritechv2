import 'package:agritechv2/blocs/product/product_bloc.dart';
import 'package:agritechv2/repository/product_repository.dart';
import 'package:agritechv2/views/reusables/featured_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../styles/color_styles.dart';
import '../../styles/text_styles.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ProductRepository(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore Products",
              style: MyTextStyles.header,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'lib/assets/images/offer1.png',
                height: 150,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: const Color(0XFFe5b2b2),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: ColorStyle.brandRed,
                          ),
                        ),
                        Text(
                          "MY FAVORITES",
                          style: MyTextStyles.size10,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: const Color(0XFFC7DBC7),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            Icons.shopping_bag,
                            color: Colors.green.shade600,
                            size: 35,
                          ),
                        ),
                        Text(
                          "INBOX",
                          style: MyTextStyles.size10,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade200,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            Icons.wallet,
                            color: Colors.yellow.shade800,
                            size: 35,
                          ),
                        ),
                        Text(
                          "MY ORDERS",
                          style: MyTextStyles.size10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(color: Colors.transparent),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Featured Products",
                  style: MyTextStyles.header,
                ),
                const SizedBox(height: 10),
                BlocProvider(
                  create: (context) => ProductBloc(
                      productRepository: context.read<ProductRepository>())
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
                        var productList = state.products;
                        return productList.isNotEmpty
                            ? SizedBox(
                                height: 160, // Set the height of the carousel
                                child: PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productList.length,
                                  itemBuilder: (context, index) {
                                    return FeaturedProductCard(
                                        product: productList[index]);
                                  },
                                ),
                              )
                            : const Center(
                                child: Text('No products available.'),
                              );
                      } else {
                        return const Center(
                          child: Text('No products available.'),
                        );
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
