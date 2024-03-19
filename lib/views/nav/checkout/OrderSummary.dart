import 'package:agritechv2/models/transaction/OrderItems.dart';
import 'package:agritechv2/models/transaction/TransactionType.dart';
import 'package:flutter/material.dart';

import '../../../models/transaction/TransactionSchedule.dart';
import '../../../utils/Constants.dart';
import '../../custom widgets/order_details_data.dart';

class OrderSummary extends StatelessWidget {
  final List<OrderItems> orders;

  final TransactionType type;
  const OrderSummary({super.key, required this.orders, required this.type});

  @override
  Widget build(BuildContext context) {
    final TransactionSchedule _schedule = TransactionSchedule.initialize();
    final shipping =
        type == TransactionType.DELIVERY ? computeShipping(orders) : 0;
    final total = computeTotalOrder(orders) + shipping;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Column(
        children: [
          const Divider(),
          OrderDetailsData(
              title: "Total items", value: "${countOrders(orders)}"),
          OrderDetailsData(
              title: "Item Total",
              value: formatPrice(computeTotalOrder(orders))),
          OrderDetailsData(title: "Shipping Fee", value: formatPrice(shipping)),
          OrderDetailsData(
              title: type == TransactionType.DELIVERY
                  ? "Estimated Delivery Time"
                  : "Estimated Pick up Time",
              value: _schedule.getFormatedSchedule()),
          OrderDetailsData(title: "Total", value: formatPrice(total))
        ],
      ),
    );
  }
}
