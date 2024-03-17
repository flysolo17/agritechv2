import 'dart:convert';
import 'dart:math';

import 'package:agritechv2/styles/color_styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../models/product/CartWithProduct.dart';
import '../../../models/product/Variations.dart';
import '../../../models/transaction/OrderItems.dart';
import '../../../repository/auth_repository.dart';
import '../../../repository/cart_repository.dart';
import '../../../utils/Constants.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, OrderItems>> orders = [];

  // List<OrderItems> orders = [];
  List<bool> selected = [];
  List<CartWithProduct> cartWithProduct = [];
  // void updateSelected(List<bool> selected) {
  //   orders.clear(); // Clear existing orders before adding new ones
  //   selected.asMap().forEach((index, isChecked) {
  //     if (isChecked) {
  //       orders.add(createOrderItems(cartWithProduct[index]));
  //     }
  //   });
  //   print("Orders : ${orders.length}");
  // }

  num computeTotalPrice(List<Map<String, OrderItems>> orders) {
    double totalPrice = 0;
    for (final orderMap in orders) {
      for (final orderItem in orderMap.values) {
        totalPrice += orderItem.price * orderItem.quantity;
      }
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.brandRed,
        title: const Text("My Cart"),
      ),
      body: StreamBuilder<List<CartWithProduct>>(
          stream: context.read<CartRepository>().getAllCartWithProductbyUID(
              context.read<AuthRepository>().currentUser?.uid ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return shimmerLoading1();
            }
            if (snapshot.hasError) {
              return const Icon(Icons.error);
            }
            if (snapshot.data != null) {
              var cartList = snapshot.data ?? [];

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        final cart = cartList[index];
                        return Dismissible(
                          key: Key(cart.cart.id),
                          onDismissed: (direction) {
                            context
                                .read<CartBloc>()
                                .add(DeleteCart(cart.cart.id));
                          },
                          child: CartCard(
                            cartWithProduct: cart,
                            selected: orders.any((orderMap) =>
                                orderMap.containsKey(cart.cart.id)),
                            onCartClicked: (bool isChecked, int max) {
                              setState(() {
                                if (isChecked) {
                                  // int max = cart.cart.isVariation ?
                                  orders.add({
                                    cart.cart.id: createOrderItems(cart, max)
                                  });
                                } else {
                                  orders.removeWhere((element) =>
                                      element.containsKey(cart.cart.id));
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            formatPrice(computeTotalPrice(orders)),
                            style: const TextStyle(
                              color: ColorStyle.brandRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          color: ColorStyle.brandRed,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextButton(
                            child: const Text(
                              "Checkout",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (orders.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("No Product to Checkout"),
                                  ),
                                );
                                return;
                              }
                              List<OrderItems> selected = orders
                                  .expand((orderMap) => orderMap.values)
                                  .toList();
                              context.push(
                                '/checkout',
                                extra: jsonEncode(
                                    selected.map((e) => e.toJson()).toList()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text("No items in cart"),
              );
            }
          }),
    );
  }

  OrderItems createOrderItems(CartWithProduct cartWithProduct, int max) {
    return OrderItems(
      productID: cartWithProduct.products.id,
      productName: cartWithProduct.products.name,
      isVariation: cartWithProduct.cart.isVariation,
      variationID: cartWithProduct.cart.variationID ?? '',
      quantity: cartWithProduct.cart.quantity,
      maxQuantity: max,
      cost: cartWithProduct.products.cost,
      price: cartWithProduct.products.price,
      imageUrl: cartWithProduct.products.images.isNotEmpty
          ? cartWithProduct.products.images[0]
          : '',
      shippingInfo: cartWithProduct.products.shippingInformation,
    );
  }
}

class CartCard extends StatelessWidget {
  final CartWithProduct cartWithProduct;
  final bool selected;

  final Function(bool selected, int max) onCartClicked;

  CartCard({
    Key? key,
    required this.cartWithProduct,
    required this.selected,
    required this.onCartClicked,
  }) : super(key: key);

  Variation? getVariationById(
      List<Variation> variationList, String? variationId) {
    return variationId != null
        ? variationList.firstWhereOrNull((v) => v.id == variationId)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final Variation? variation = getVariationById(
        cartWithProduct.products.variations, cartWithProduct.cart.variationID);

    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartSuccessState<String>) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${state.data}')));
        }
        if (state is CartErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${state.error}')));
        }
      },
      builder: (context, state) {
        return state is CartLoadingState
            ? shimmerLoading1()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: selected,
                    onChanged: (bool? value) {
                      onCartClicked(
                        value ?? false,
                        variation != null
                            ? variation.stocks
                            : cartWithProduct.products.stocks,
                      );
                    },
                  ),
                  Expanded(
                    child: ListTile(
                      leading: Image.network(
                        variation != null
                            ? variation.image
                            : cartWithProduct.products.images[0],
                        height: double.infinity,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        variation != null
                            ? variation.name
                            : cartWithProduct.products.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            variation != null
                                ? formatPrice(variation.price *
                                    cartWithProduct.cart.quantity)
                                : formatPrice(cartWithProduct.products.price *
                                    cartWithProduct.cart.quantity),
                          ),
                          InputQty(
                            maxVal: variation != null
                                ? variation.stocks
                                : cartWithProduct.products.stocks,
                            initVal: cartWithProduct.cart.quantity,
                            minVal: 1,
                            steps: 1,
                            onQtyChanged: (val) {
                              context.read<CartBloc>().add(UpdateCartQuantity(
                                  cartWithProduct.cart.id, val));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
