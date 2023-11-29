import 'dart:convert';

import 'package:agritechv2/models/product/Cart.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/cart_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';

class CartAction extends StatefulWidget {
  const CartAction({super.key});

  @override
  State<CartAction> createState() => _CartActionState();
}

class _CartActionState extends State<CartAction> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Cart>>(
        stream: context
            .read<CartRepository>()
            .getCartByUID(context.read<AuthRepository>().currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          }

          if (snapshot.data != null) {
            var cartList = snapshot.data ?? [];
            return badges.Badge(
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              badgeAnimation: const badges.BadgeAnimation.slide(),
              showBadge: true,
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
              ),
              badgeContent: Text(
                cartList.length.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 8.0),
              ),
              child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => context.push("/cart",
                      extra: jsonEncode(
                          cartList.map((e) => e.toJson()).toList()))),
            );
          } else {
            return const Icon(Icons.error);
          }
        });
  }
}

class CartIcon extends StatelessWidget {
  final Icon icon;
  final int badgeCount;

  CartIcon({required this.icon, required this.badgeCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          icon,
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 14,
                minHeight: 14,
              ),
              child: Center(
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
