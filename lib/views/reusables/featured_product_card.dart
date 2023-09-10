import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/Products.dart';

class FeaturedProductCard extends StatelessWidget {
  final Products product;

  const FeaturedProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(10), // Adjust the radius as needed
        ),
        child: SizedBox(
          height: 125, // Set the desired height for the image
          child: product.image != null
              ? Image.network(
                  product.image!,
                  fit: BoxFit.fitHeight,
                )
              : const Icon(Icons.image),
        ),
      ),
    );
  }
}
