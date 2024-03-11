// import 'dart:convert';

// import 'package:agritechv2/models/product/Products.dart';
// import 'package:agritechv2/models/transaction/OrderItems.dart';
// import 'package:agritechv2/repository/product_repository.dart';
// import 'package:agritechv2/views/custom%20widgets/button.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:input_quantity/input_quantity.dart';

// import '../../../blocs/cart/cart_bloc.dart';
// import '../../../models/product/Cart.dart';

// import '../../../models/product/Shipping.dart';
// import '../../../models/product/Variations.dart';
// import '../../../repository/auth_repository.dart';
// import '../../../repository/cart_repository.dart';

// import '../../../styles/color_styles.dart';
// import '../../../utils/Constants.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   List<OrderItems> _orderItems = [];

//   void addItem(OrderItems newItem, bool isChecked) {
//     setState(() {
//       if (isChecked) {
//         _orderItems.add(newItem);
//       } else {
//         removeItem(newItem.productID);
//       }
//     });
//   }

//   void removeItem(String productID) {
//     _orderItems.removeWhere((item) => item.productID == productID);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorStyle.brandRed,
//         title: const Text("My Cart"),
//       ),
//       body: StreamBuilder<List<Cart>>(
//         stream: context
//             .read<CartRepository>()
//             .getCartByUID(context.read<AuthRepository>().currentUser!.uid),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(snapshot.error.toString()),
//             );
//           }
//           if (snapshot.data != null) {
//             var cartList = snapshot.data ?? [];

//             return BlocProvider(
//               create: (context) =>
//                   CartBloc(cartRepository: context.read<CartRepository>()),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: cartList.length,
//                       itemBuilder: (context, index) {
//                         return CartContainer(
//                           cartItem: cartList[index],
//                           onSelect: (OrderItems orderItems, bool isChecked) {
//                             addItem(orderItems, isChecked);
//                             print(_orderItems.length);
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(10.0),
//                     color: Colors.white,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Text(
//                             formatPrice(computeTotalOrder(_orderItems)),
//                             style: const TextStyle(
//                                 color: ColorStyle.brandRed,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18),
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             if (_orderItems.isEmpty) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                       content: Text("No Product to Checkout")));
//                               return;
//                             }
//                             context.push('/checkout',
//                                 extra: jsonEncode(_orderItems
//                                     .map((e) => e.toJson())
//                                     .toList()));
//                           },
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   10), // Set borderRadius to 0 for non-rounded edges
//                             ),
//                             backgroundColor: ColorStyle
//                                 .brandRed, // Set the button color to red
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               "Checkout (${countOrders(_orderItems)})",
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return const Center(
//               child: Text("No product yet!"),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class CartContainer extends StatefulWidget {
//   final Cart cartItem;
//   final Function(OrderItems orderItems, bool isChecked) onSelect;

//   CartContainer({
//     super.key,
//     required this.cartItem,
//     required this.onSelect,
//   });

//   @override
//   State<CartContainer> createState() => _CartContainerState();
// }

// class _CartContainerState extends State<CartContainer> {
//   bool isChecked = false;
//   @override
//   Widget build(BuildContext context) {
//     Variation? getVariationById(
//         List<Variation> variationList, String? variationId) {
//       return variationId != null
//           ? variationList.firstWhereOrNull((v) => v.id == variationId)
//           : null;
//     }

//     return FutureBuilder<Products>(
//       future: context
//           .read<ProductRepository>()
//           .getProductById(widget.cartItem.productID),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return shimmerLoading1(); // Loading indicator
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData) {
//           return const Text('Product not found');
//         } else {
//           final product = snapshot.data!;
//           final Variation? variation =
//               getVariationById(product.variations, widget.cartItem.variationID);

//           return Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Checkbox(
//                 value: isChecked,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     isChecked = value!;
//                   });
//                   widget.onSelect(
//                     OrderItems(
//                       productID: product.id,
//                       productName:
//                           variation != null ? variation.name : product.name,
//                       isVariation: widget.cartItem.isVariation,
//                       variationID: variation?.id ?? "",
//                       quantity: widget.cartItem.quantity,
//                       cost: variation != null ? variation.cost : product.cost,
//                       price:
//                           variation != null ? variation.price : product.price,
//                       imageUrl: variation != null && variation.image.isNotEmpty
//                           ? variation.image
//                           : product.images[0],
//                       shippingInfo: product.shippingInformation,
//                     ),
//                     isChecked,
//                   );
//                 },
//               ),
//               Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: variation != null && variation.image.isNotEmpty
//                         ? NetworkImage(variation.image)
//                         : NetworkImage(product.images[0]),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       variation != null ? variation.name : product.name,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         fontStyle: FontStyle.normal,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       variation != null
//                           ? formatPrice(
//                               variation.price * widget.cartItem.quantity)
//                           : formatPrice(
//                               product.price * widget.cartItem.quantity),
//                     ),
//                     InputQty(
//                       maxVal:
//                           variation != null ? variation.stocks : product.stocks,
//                       initVal: widget.cartItem.quantity,
//                       minVal: 1,
//                       steps: 1,
//                       onQtyChanged: (val) {
//                         context
//                             .read<CartBloc>()
//                             .add(UpdateCartQuantity(widget.cartItem.id, val));
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         }
//       },
//     );
//   }
// }
