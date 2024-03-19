import 'package:flutter/material.dart';
import '../../../models/transaction/OrderItems.dart';
import '../../../models/transaction/TransactionType.dart';
import '../../custom widgets/order_item_container.dart';

class OrderDetails extends StatelessWidget {
  final List<OrderItems> orderList;
  final TransactionType type;
  final Function(int index, int value) changeQuantity;

  OrderDetails({
    required this.orderList,
    required this.type,
    required this.changeQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/images/logo.png",
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Agritech",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            )
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            OrderItems orderItems = orderList[index];
            return OrderItemContainer(
              orderItems: orderItems,
              changeQuantity: (value) {
                changeQuantity(index, value);
              },
              type: type,
            );
          },
        ),
      ],
    );
  }
}
