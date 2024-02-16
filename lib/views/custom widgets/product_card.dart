import 'package:agritechv2/repository/audit_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../models/product/Products.dart';
import '../../utils/Constants.dart';

class ProductCard extends StatefulWidget {
  final Products product;

  const ProductCard(this.product, {super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Products? _oldProduct = null;

  @override
  void initState() {
    _getProductData();
    super.initState();
  }

  Future<void> _getProductData() async {
    try {
      final product = await context
          .read<AuditRepository>()
          .getAuditByProductID(widget.product.id);
      setState(() {
        _oldProduct = product;
      });
    } catch (e) {
      print("Error getting product data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/product/${widget.product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: widget.product.images.isNotEmpty
                    ? Image.network(
                        widget.product.images[0],
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${getEffectivePrice(widget.product)}",
                    style: const TextStyle(
                        color: ColorStyle.brandRed,
                        fontWeight: FontWeight.bold),
                  ),
                  if (_oldProduct != null &&
                      getEffectivePrice(widget.product) !=
                          getEffectivePrice(_oldProduct!))
                    Text(
                      getEffectivePrice(_oldProduct!),
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.black),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
