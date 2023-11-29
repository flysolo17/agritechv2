import 'package:agritechv2/utils/Constants.dart';
import 'package:agritechv2/views/custom%20widgets/order_details_data.dart';
import 'package:flutter/material.dart';

class OrderSummaryContainer extends StatelessWidget {
  final num subtotal;
  final num shippingFee;
  const OrderSummaryContainer(
      {super.key, required this.subtotal, required this.shippingFee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(10.0),
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OrderDetailsData(
              title: "Subtotal",
              value: formatPrice(subtotal),
              textSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OrderDetailsData(
              title: "Shipping Fee",
              value: formatPrice(shippingFee),
              textSize: 14,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  formatPrice(subtotal + shippingFee),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
