import 'dart:convert';

import 'package:agritechv2/models/Address.dart';
import 'package:agritechv2/models/transaction/PaymentMethod.dart';
import 'package:agritechv2/models/transaction/TransactionDetails.dart';
import 'package:agritechv2/models/transaction/TransactionStatus.dart';
import 'package:agritechv2/models/transaction/Transactions.dart';
import 'package:agritechv2/models/users/Customer.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:agritechv2/repository/transaction_repository.dart';

import 'package:agritechv2/views/nav/checkout/CustomerInfo.dart';
import 'package:agritechv2/views/nav/checkout/DeliveryOptions.dart';
import 'package:agritechv2/views/nav/checkout/MessageCard.dart';
import 'package:agritechv2/views/nav/checkout/OrderDetails.dart';
import 'package:agritechv2/views/nav/checkout/OrderSummary.dart';
import 'package:agritechv2/views/nav/checkout/PaymentMethods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/transactions/transactions_bloc.dart';
import '../../../models/transaction/OrderItems.dart';
import '../../../models/transaction/TransactionType.dart';
import '../../../styles/color_styles.dart';
import '../../../utils/Constants.dart';
import '../../custom widgets/order_confirmed_page.dart';
import '../../custom widgets/order_details_data.dart';

class CheckoutPage extends StatefulWidget {
  final List<OrderItems> orderItems;
  const CheckoutPage({super.key, required this.orderItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _message = '';

  Stream<Customer>? _customerStream;
  Customer? _customer;
  TransactionType _transactionType = TransactionType.DELIVERY;
  PaymentType? _paymentType;

  @override
  void initState() {
    _customerStream = context
        .read<UserRepository>()
        .getCustomer(context.read<AuthRepository>().currentUser!.uid);
    _customerStream?.listen((customer) {
      setState(() {
        _customer = customer;
      });
    });
    super.initState();
  }

  List<bool> _paymentMethod = [true, false, false];
  @override
  void dispose() {
    _customerStream?.listen(null).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: ColorStyle.brandRed,
      ),
      backgroundColor: ColorStyle.checkoutBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomerInfo(
              customer: _customer,
              type: _transactionType,
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  OrderDetails(
                    orderList: widget.orderItems,
                    type: _transactionType,
                    changeQuantity: (index, value) {
                      setState(() {
                        widget.orderItems[index].quantity = value;
                      });
                    },
                  ),
                  const Divider(),
                  OrderDetailsData(
                      title: "Sub Total",
                      value: formatPrice(computeTotalOrder(widget.orderItems))),
                  const Divider(),
                  MessageContainer(
                      message: _message,
                      onMessageChange: (message) {
                        setState(() {
                          _message = message;
                          print(_message);
                        });
                      }),
                  const Divider(),
                  const Text(
                    "Orders placed outside business hours (9:00 AM to 3:00 PM) will be processed during our next open hours",
                    style: TextStyle(
                      fontSize: 10,
                      color: ColorStyle.brandRed,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            DeliveryOptions(
                type: _transactionType,
                onTypeChange: (type) {
                  setState(() {
                    _transactionType = type;
                    _paymentType = null;
                    for (int i = 0; i < _paymentMethod.length; i++) {
                      _paymentMethod[i] = false;
                    }
                    print(_paymentMethod);
                  });
                }),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Payment Methods",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  PaymentMethods(
                      transactionType: _transactionType,
                      paymentMethod: (data) {
                        setState(() {
                          _paymentType = getSelectedPaymentMethod(data);
                          _paymentMethod[data] = true;
                        });
                      },
                      isSelected: _paymentMethod),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Sumary",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  OrderSummary(
                      orders: widget.orderItems, type: _transactionType),
                  ConfirmCheckout(
                    orders: widget.orderItems,
                    transactionType: _transactionType,
                    paymentType: _paymentType,
                    customer: _customer,
                    message: _message,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return OrderConfirmPage(onTap: () {
        context.go('/');
      });
    },
  );
}

class ConfirmCheckout extends StatelessWidget {
  final List<OrderItems> orders;
  final TransactionType transactionType;
  final PaymentType? paymentType;
  final Customer? customer;
  final String message;

  const ConfirmCheckout({
    super.key,
    required this.orders,
    required this.transactionType,
    required this.paymentType,
    required this.customer,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final shipping = transactionType == TransactionType.DELIVERY
        ? computeShipping(orders)
        : 0;
    final total = computeTotalOrder(orders) + shipping;
    final transactions = Transactions(
        id: '',
        customerID: customer?.id ?? '',
        driverID: '',
        cashierID: '',
        type: transactionType,
        orderList: orders,
        address: customer?.getDefaultAddress(),
        message: message,
        status: TransactionStatus.PENDING,
        details: [
          Details(
              updatedBy: customer?.name ?? '',
              message: "Order Placed",
              status: TransactionStatus.PENDING,
              updatedAt: DateTime.now())
        ],
        payment: Payment(
            amount: total,
            type: paymentType ?? PaymentType.COD,
            status: PaymentStatus.UNPAID),
        createdAt: DateTime.now());
    return BlocProvider(
      create: (context) => TransactionsBloc(
          transactionRepostory: context.read<TransactionRepostory>()),
      child: BlocConsumer<TransactionsBloc, TransactionsState>(
        listener: (context, state) {
          if (state is TransactionsFailedState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is TransactionsSuccessState<String>) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("order placed")));
            if (paymentType == PaymentType.GCASH && state.data.isNotEmpty) {
              Future.delayed(const Duration(seconds: 1), () {
                context.push('/gcash-payment', extra: {
                  'transactionID': state.data,
                  'payment': jsonEncode(transactions.payment),
                  'customer': customer?.name ?? ''
                });
              });
            } else {
              _showBottomSheet(context);
            }
          }
        },
        builder: (context, state) {
          return state is TransactionsLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      if (paymentType == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please Select Payment Type")));
                        return;
                      }
                      if (countOrders(orders) < 50) {
                        if (areAllItemsAboveMinimum(orders) == false &&
                            transactionType == TransactionType.DELIVERY) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Order is less than the minimum requirements")));
                          return;
                        }
                      }
                      if (transactionType == TransactionType.DELIVERY &&
                          transactions.address == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please add address")));
                        return;
                      }
                      print(message);
                      context.read<TransactionsBloc>().add(
                            SubmitTransactionEvent(transactions),
                          );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorStyle.brandRed,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          paymentType == PaymentType.GCASH
                              ? "Next (${formatPrice(total)})"
                              : "Place order (${formatPrice(total)})",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  void placeOrder(BuildContext context, Transactions transactions) {}
}
