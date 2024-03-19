import 'dart:ffi';

import 'package:agritechv2/models/product/Products.dart';
import 'package:agritechv2/models/transaction/OrderItems.dart';
import 'package:agritechv2/models/transaction/TransactionType.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../utils/Constants.dart';

class OrderItemContainer extends StatelessWidget {
  final OrderItems orderItems;
  Function(int quantity) changeQuantity;
  final TransactionType type;
  OrderItemContainer(
      {super.key,
      required this.orderItems,
      required this.changeQuantity,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      padding: const EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              image: DecorationImage(
                image: NetworkImage(orderItems.imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        orderItems.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                        ),
                      ),
                      if (type == TransactionType.DELIVERY &&
                          orderItems.shippingInfo.minimum > orderItems.quantity)
                        Text(
                          'minimum of ${orderItems.shippingInfo.minimum} items',
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 12,
                              color: Colors.red[400]),
                        ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatPrice(orderItems.price * orderItems.quantity),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                      InputQty(
                        maxVal: orderItems.maxQuantity,
                        initVal: orderItems.quantity,
                        minVal: 1,
                        steps: 1,
                        onQtyChanged: (val) {
                          changeQuantity(val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
