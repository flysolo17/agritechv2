import 'package:agritechv2/models/transaction/TransactionDetails.dart';
import 'package:agritechv2/models/transaction/TransactionStatus.dart';
import 'package:agritechv2/models/transaction/Transactions.dart';
import 'package:agritechv2/repository/transaction_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/transaction/OrderItems.dart';
import '../../../utils/Constants.dart';

class ViewOrderPage extends StatelessWidget {
  final String transactionID;
  const ViewOrderPage({super.key, required this.transactionID});

  @override
  Widget build(BuildContext context) {
    print(transactionID);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Order"),
        backgroundColor: ColorStyle.brandRed,
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                "Download",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<Transactions>(
        future: context
            .read<TransactionRepostory>()
            .getTransactionsByID(transactionID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('Transaction not found'),
            );
          }

          // Transaction data is available
          Transactions transaction = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                OrdersDetailsContainer(
                    title: "Transaction",
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Transaction ID : ${transactionID}"),
                        Text(
                            "Order Date: ${formatDateTime(transaction.createdAt)}"),
                        Text(
                            "Estimated Schedule: ${transaction.schedule?.getFormatedSchedule()}"),
                      ],
                    )),
                OrdersDetailsContainer(
                  title: "Order Items",
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: transaction.orderList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final OrderItems items = transaction.orderList[index];
                          return ListTile(
                            leading: Image.network(
                              items.imageUrl,
                              fit: BoxFit.cover,
                            ),
                            title: Text(items.productName),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatPrice(items.price * items.quantity),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "x${items.quantity}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            // You can add other content and widgets as needed.
                          );
                        },
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Total : ${formatPrice(transaction.payment.amount)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                OrdersDetailsContainer(
                    title: "Track order",
                    widget: TransactionDetails(details: transaction.details))
              ],
            ),
          );
        },
      ),
    );
  }
}

class OrdersDetailsContainer extends StatelessWidget {
  final String title;
  final Widget widget;
  const OrdersDetailsContainer(
      {super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          widget
        ],
      ),
    );
  }
}

class TransactionDetails extends StatelessWidget {
  final List<Details> details;
  const TransactionDetails({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: AnotherStepper(
        stepperList: details.reversed.mapIndexed((index, e) {
          return StepperData(
              title: StepperText(
                e.status.name,
                textStyle: TextStyle(
                  color: getColor(e.status),
                ),
              ),
              subtitle: StepperText(
                '${formatDateTime(e.updatedAt)}\n${e.message}',
                textStyle: TextStyle(
                  color: getColor(e.status),
                ),
              ),
              iconWidget: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: getColor(e.status),
                    borderRadius: const BorderRadius.all(Radius.circular(30))),
              ));
        }).toList(),
        stepperDirection: Axis.vertical,
        iconWidth: 10,
        iconHeight: 10,
        activeBarColor: Colors.green,
        inActiveBarColor: Colors.grey,
        activeIndex: 0,
        barThickness: 1,
      ),
    );
  }
}
