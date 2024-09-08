import 'dart:convert';

import 'package:agritechv2/models/product/Products.dart';
import 'package:agritechv2/views/custom%20widgets/button.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../models/transaction/OrderItems.dart';
import '../../../styles/color_styles.dart';

class BuyNowPage extends StatefulWidget {
  final Products products;
  const BuyNowPage({super.key, required this.products});

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  int _selectedIndex = -1;
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ColorStyle.brandRed, width: 1.0),
                ),
                margin: const EdgeInsets.all(5.0),
                width: 100,
                height: 100,
                child: _selectedIndex == -1
                    ? Image.network(
                        widget.products.images[0],
                        fit: BoxFit.contain,
                      )
                    : widget.products.variations[_selectedIndex].image.isEmpty
                        ? Image.asset(
                            'lib/assets/images/no_image.png',
                            fit: BoxFit.contain,
                          )
                        : Image.network(
                            widget.products.variations[_selectedIndex].image,
                            fit: BoxFit.contain,
                          ),
              ),
              if (_selectedIndex != -1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₱ ${widget.products.variations[_selectedIndex].price}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorStyle.brandGreen),
                    ),
                    Text(
                      "Stocks : ${widget.products.variations[_selectedIndex].stocks}",
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                )
            ],
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Variations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            spacing: 5.0,
            runSpacing: 8.0,
            children: widget.products.variations.mapIndexed(
              (index, variation) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedIndex == index
                            ? ColorStyle.brandRed
                            : Colors.transparent,
                        width: 1.0,
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        variation.image.isNotEmpty
                            ? Image.network(
                                variation.image,
                                fit: BoxFit.contain,
                                height: 25,
                                width: 25,
                              )
                            : Image.asset(
                                'lib/assets/images/no_image.png',
                                fit: BoxFit.contain,
                                height: 25,
                                width: 25,
                              ),
                        Text(
                          variation.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).toList(),
          ),
          const Divider(),
          if (_selectedIndex != -1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Quantity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InputQty(
                    maxVal: widget.products.variations[_selectedIndex].stocks,
                    initVal: 1,
                    minVal: 1,
                    steps: 1,
                    onQtyChanged: (val) {
                      setState(() {
                        _quantity = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: _selectedIndex == -1 ||
                    widget.products.variations[_selectedIndex].stocks < 1
                ? null
                : () {
                    OrderItems orderItems = OrderItems(
                        productID: widget.products.id,
                        productName: widget.products.name,
                        isVariation: true,
                        variationID:
                            widget.products.variations[_selectedIndex].id,
                        quantity: _quantity,
                        maxQuantity:
                            widget.products.variations[_selectedIndex].stocks,
                        cost: widget.products.variations[_selectedIndex].cost,
                        price: widget.products.variations[_selectedIndex].price,
                        imageUrl:
                            widget.products.variations[_selectedIndex].image,
                        shippingInfo: widget.products.shippingInformation);
                    List<OrderItems> orderList = [orderItems];
                    context.push('/checkout',
                        extra: jsonEncode(
                            orderList.map((e) => e.toJson()).toList()));
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _selectedIndex == -1 ? Colors.grey : ColorStyle.brandRed,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(
              _selectedIndex == -1 ? "Select a variation" : "Buy Now",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
