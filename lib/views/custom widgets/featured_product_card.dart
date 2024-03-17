import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/product/Products.dart';
import '../../models/transaction/OrderItems.dart';

class FeaturedProductCard extends StatelessWidget {
  final Products product;

  const FeaturedProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    bool isVariation = product.variations.isEmpty ? false : true;
    OrderItems orderItems = OrderItems(
        productID: product.id,
        productName: product.name,
        isVariation: isVariation,
        variationID: isVariation ? product.variations[0].id : "",
        quantity: 1,
        maxQuantity:
            isVariation ? product.variations[0].stocks : product.stocks,
        cost: isVariation ? product.variations[0].cost : product.cost,
        price: isVariation ? product.variations[0].price : product.price,
        imageUrl: product.images[0],
        shippingInfo: product.shippingInformation);
    List<OrderItems> orderList = [orderItems];

    return GestureDetector(
      onTap: () => context.push('/checkout',
          extra: jsonEncode(orderList.map((e) => e.toJson()).toList())),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: NetworkImage(product.images[0]), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
