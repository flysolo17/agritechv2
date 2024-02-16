import 'dart:convert';

import 'package:agritechv2/blocs/transactions/transactions_bloc.dart';
import 'package:agritechv2/models/users/Customer.dart';
import 'package:agritechv2/models/transaction/OrderItems.dart';
import 'package:agritechv2/models/transaction/PaymentMethod.dart';
import 'package:agritechv2/models/transaction/TransactionStatus.dart';
import 'package:agritechv2/models/transaction/Transactions.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/transaction_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/utils/Constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../repository/customer_repository.dart';
import '../../custom widgets/button.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: TransactionStatus.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          backgroundColor: ColorStyle.brandRed,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: TransactionStatus.values
                .map((e) => Tab(
                      text: e.name.replaceAll("_", " "),
                    ))
                .toList(),
          ),
        ),
        backgroundColor: Colors.grey[100],
        body: StreamBuilder<Customer>(
            stream: context
                .read<UserRepository>()
                .getCustomer(context.read<AuthRepository>().currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator()); // Loading indicator
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: //${snapshot.error}'));
              } else if (snapshot.hasData) {
                Customer customer = snapshot.data!;

                return BlocProvider(
                  create: (context) => TransactionsBloc(
                      transactionRepostory:
                          context.read<TransactionRepostory>()),
                  child: TabBarView(
                    children: TransactionStatus.values.map((e) {
                      return TransactionList(
                        status: e,
                        customer: customer,
                      );
                    }).toList(),
                  ),
                );
              } else {
                return const Center(child: Text('User not found.'));
              }
            }),
      ),
    );
  }
}

class TransactionList extends StatefulWidget {
  final TransactionStatus status;
  final Customer customer;
  const TransactionList(
      {super.key, required this.status, required this.customer});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  void initState() {
    context.read<TransactionsBloc>().add(GetTransactionsByStatus(
        widget.status, context.read<AuthRepository>().currentUser!.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state is TransactionsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionsSuccessState) {
          List<Transactions> transactions = state.data;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionsContainer(
                transactions: transaction,
                customer: widget.customer,
              );
            },
          );
        } else if (state is TransactionsFailedState) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(
            child: Text("No data"),
          );
        }
      },
    );
  }
}

class TransactionsContainer extends StatelessWidget {
  final Transactions transactions;
  final Customer customer;
  const TransactionsContainer(
      {super.key, required this.transactions, required this.customer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push("/view-order/${transactions.id}"),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (transactions.payment.status == PaymentStatus.PAID &&
                    transactions.payment.type == PaymentType.GCASH)
                  const Text(
                    "Paid via GCASH",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                const Text(
                  "",
                ),
                Text(transactions.status.name.replaceAll("_", " ")),
              ],
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[100],
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('hh:mm a').format(transactions
                        .details[transactions.details.length - 1].updatedAt),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    transactions
                        .details[transactions.details.length - 1].message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: transactions.orderList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final OrderItems items = transactions.orderList[index];
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "x${items.quantity}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Total : ${formatPrice(transactions.payment.amount)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (transactions.status == TransactionStatus.PENDING)
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorStyle.brandRed,
                          ),
                          onPressed: () {
                            context.push('/cancel', extra: transactions);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      if (transactions.payment.status == PaymentStatus.UNPAID)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.brandGreen,
                            ),
                            onPressed: () {
                              context.push('/gcash-payment', extra: {
                                'transactionID': transactions.id,
                                'payment': jsonEncode(transactions.payment),
                                'customer': customer.name
                              });
                            },
                            child: const Text(
                              'Pay now',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (transactions.status == TransactionStatus.COMPLETED)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.brandGreen,
                    ),
                    onPressed: () {
                      context.push('/rate', extra: transactions);
                    },
                    child: const Text(
                      'Rate',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // void _showBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     elevation: 0,
  //     backgroundColor: Colors.white,
  //     builder: (BuildContext context) {
  //       return Container(
  //         width: double.infinity,
  //         padding: EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             const Text(
  //               'What is the biggest reason for your wish to cancel ?',
  //               style: TextStyle(fontSize: 16.0),
  //             ),
  //             const TextField(
  //               decoration: InputDecoration(labelText: 'Message'),
  //               maxLines: 3,
  //             ),
  //             const SizedBox(height: 16.0),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                   backgroundColor: ColorStyle.brandRed, elevation: 0),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: const Text('Confirm Cancellation'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
