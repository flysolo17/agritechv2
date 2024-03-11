// ignore_for_file: must_be_immutable

import 'package:agritechv2/blocs/cart/cart_bloc.dart';
import 'package:agritechv2/models/product/Shipping.dart';
import 'package:agritechv2/models/transaction/OrderItems.dart';
import 'package:agritechv2/repository/cart_repository.dart';
import 'package:agritechv2/repository/product_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/utils/Constants.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../../models/product/Cart.dart';
import '../../../models/product/Products.dart';
import '../../../models/product/Variations.dart';

class CartItemListPage extends StatelessWidget {
  List<Cart> cartItems;
  CartItemListPage({super.key, required this.cartItems});

  List<OrderItems> orderList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorStyle.brandRed,
          title: Text("My Cart : ${cartItems.length}"),
        ),
        body: Column(
          children: [
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(
                      child: Text('No items'),
                    )
                  : SizedBox(
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (context, index) {
                          return BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                              return CartContainer(
                                  cartItem: cartItems[index],
                                  onSelect: (shipping, value) {
                                    if (value) {}
                                  });
                            },
                          );
                        },
                        itemCount: cartItems.length,
                      ),
                    ),
            ),
          ],
        ));
  }
}

class CartContainer extends StatefulWidget {
  final Cart cartItem;
  Function(ShippingInfo shippingInfo, bool value) onSelect;

  CartContainer({
    super.key,
    required this.cartItem,
    required this.onSelect,
  });

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    Variation? getVariationById(
        List<Variation> variationList, String? variationId) {
      return variationId != null
          ? variationList.firstWhereOrNull((v) => v.id == variationId)
          : null;
    }

    return StreamBuilder<Products>(
        stream: context
            .read<ProductRepository>()
            .getProductStreamById(widget.cartItem.productID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return shimmerLoading1(); // Loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('Product not found');
          } else {
            final product = snapshot.data!;
            final Variation? variation = getVariationById(
                product.variations, widget.cartItem.variationID);

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                        widget.onSelect(product.shippingInformation, isChecked);
                      });
                    }),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: variation != null && variation.image.isNotEmpty
                          ? NetworkImage(variation.image)
                          : NetworkImage(product.images[0]),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        variation != null ? variation.name : product.name,
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
                        variation != null
                            ? formatPrice(
                                variation.price * widget.cartItem.quantity)
                            : formatPrice(
                                product.price * widget.cartItem.quantity),
                      ),
                      InputQty(
                        maxVal: variation != null
                            ? variation.stocks
                            : product.stocks,
                        initVal: widget.cartItem.quantity,
                        minVal: 1,
                        steps: 1,
                        onQtyChanged: (val) {
                          context
                              .read<CartBloc>()
                              .add(UpdateCartQuantity(widget.cartItem.id, val));
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        });
  }
}
