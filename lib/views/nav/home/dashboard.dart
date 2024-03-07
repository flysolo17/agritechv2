import 'dart:convert';

import 'package:agritechv2/blocs/favorites/favorites_bloc.dart';
import 'package:agritechv2/models/favorites/favorites.dart';
import 'package:agritechv2/repository/favorites_repository.dart';
import 'package:agritechv2/repository/product_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/product/Products.dart';
import '../../../models/transaction/OrderItems.dart';
import '../../../repository/auth_repository.dart';
import '../../../styles/color_styles.dart';
import '../../../styles/text_styles.dart';
import '../../custom widgets/featured_product_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesBloc(
          favoritesRepository: context.read<FavoritesRepository>(),
          customerID: context.read<AuthRepository>().currentUser?.uid ?? ''),
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
                        GestureDetector(
                          onTap: () {
                            context.push("/favorites");
                          },
                          child: Container(
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
                        GestureDetector(
                          onTap: () => context.push('/inbox'),
                          child: Container(
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
                        GestureDetector(
                          onTap: () => context.push("/my-orders"),
                          child: Container(
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
                const FeaturedProducts()
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FeaturedProducts extends StatefulWidget {
  const FeaturedProducts({super.key});

  @override
  State<FeaturedProducts> createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, // Set the height of the carousel
      child: StreamBuilder<List<Products>>(
          stream: context.read<ProductRepository>().getFeaturedProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.stackTrace}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data != null) {
              var productsList = snapshot.data ?? [];
              return PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productsList.length,
                itemBuilder: (context, index) {
                  return FeaturedProductCard(product: productsList[index]);
                },
              );
            } else {
              return const Center(
                child: Text("No Featured Products yet"),
              );
            }
          }),
    );
  }
}
