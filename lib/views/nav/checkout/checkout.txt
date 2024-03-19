import 'dart:convert';
import 'dart:ffi';

import 'package:agritechv2/blocs/customer/customer_bloc.dart';
import 'package:agritechv2/blocs/transactions/transactions_bloc.dart';
import 'package:agritechv2/models/Address.dart';
import 'package:agritechv2/models/users/Customer.dart';
import 'package:agritechv2/models/transaction/PaymentMethod.dart';
import 'package:agritechv2/models/transaction/TransactionSchedule.dart';
import 'package:agritechv2/models/transaction/TransactionType.dart';
import 'package:agritechv2/models/transaction/Transactions.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:agritechv2/repository/transaction_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/views/custom%20widgets/button.dart';
import 'package:agritechv2/views/nav/checkout/gcash_payment.dart';
import 'package:agritechv2/views/custom%20widgets/order_confirmed_page.dart';
import 'package:agritechv2/views/custom%20widgets/order_details_data.dart';
import 'package:agritechv2/views/custom%20widgets/order_item_container.dart';
import 'package:agritechv2/views/custom%20widgets/order_summary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/transaction/OrderItems.dart';
import '../../../models/transaction/ShippingFee.dart';
import '../../../models/transaction/TransactionDetails.dart';
import '../../../models/transaction/TransactionStatus.dart';
import '../../../utils/Constants.dart';

class CheckOutPage extends StatefulWidget {
  final List<OrderItems> orderItems;
  const CheckOutPage({super.key, required this.orderItems});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  Address? getDefaultAddress(List<Address> addresses) {
    Address? address;
    try {
      address = addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      print(e.toString());
      return null;
    }
    return address;
  }

  TransactionType _transactionType = TransactionType.DELIVERY;
  PaymentType _paymentType = PaymentType.COD;
  List<bool> isSelected = [true, false, false];
  final TransactionSchedule _schedule = TransactionSchedule.initialize();

  num _total = 0;
  num _shipping = 0;
  num _totalItems = 0;
  String _message = "";

  @override
  void initState() {
    super.initState();
    changeDetails();
  }

  void changeDetails() {
    setState(() {
      _total = computeTotalOrder(widget.orderItems);
      _totalItems = countOrders(widget.orderItems);
      _shipping = _transactionType == TransactionType.DELIVERY
          ? computeShipping(widget.orderItems)
          : 0;
      print("SHIPPING FEE : $_shipping");
      print("ORDER ITEMS : ${widget.orderItems.length}");
      print("ORDER TYPE : ${_transactionType.name}");
      // _shipping = computeShipping(widget.orderItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: ColorStyle.brandRed,
        actions: [
          PopupMenuButton<TransactionType>(
            initialValue: _transactionType,
            // Callback that sets the selected popup menu item.
            onSelected: (TransactionType item) {
              setState(() {
                _transactionType = item;
                changeDetails();
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<TransactionType>>[
              const PopupMenuItem<TransactionType>(
                value: TransactionType.DELIVERY,
                child: Text('DELIVERY'),
              ),
              const PopupMenuItem<TransactionType>(
                value: TransactionType.PICK_UP,
                child: Text('PICK UP'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: ColorStyle.checkoutBackground,
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
              Address? defaultAddress = getDefaultAddress(customer.addresses);
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                _transactionType == TransactionType.DELIVERY
                                    ? "Shipping Details"
                                    : "Pick up Details",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            ShippingDetails(
                                address: defaultAddress,
                                uid: customer.id,
                                type: _transactionType),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Order Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            OrderDetails(
                              orderList: widget.orderItems,
                              transactionType: _transactionType,
                              schedule: _schedule,
                              message: _message,
                              changeQuantity: (index, value) {
                                widget.orderItems[index].quantity = value;
                                changeDetails();
                              },
                              onMessageChange: (value) {
                                setState(() {
                                  _message = value;
                                });
                              },
                              total: _total,
                              shipping: _shipping,
                              totalWeight: _totalItems,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Payment Method",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            PaymentTypeToggle(
                              isSelected: isSelected,
                              transactionType: _transactionType,
                              paymentMethod: (type) {
                                setState(() {
                                  isSelected[type] = true;
                                  _paymentType = getSelectedPaymentMethod(type);
                                  print(_paymentType.name);
                                });
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Order Summary",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            OrderSummaryContainer(
                                subtotal: _total, shippingFee: _shipping)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.white,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Text(
                                formatPrice(_total + _shipping),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        CheckoutActions(
                          customerID: customer.id,
                          orderList: widget.orderItems,
                          shippingFee:
                              _transactionType == TransactionType.DELIVERY
                                  ? ShippingFee(
                                      totalItems: _totalItems,
                                      shippingFee: _shipping)
                                  : null,
                          details: Details(
                              updatedBy: customer.name,
                              message: "Pending order",
                              status: TransactionStatus.PENDING,
                              updatedAt: DateTime.now()),
                          payment: Payment(
                              amount: _total + _shipping,
                              type: _paymentType,
                              status: PaymentStatus.UNPAID),
                          message: _message,
                          address: _transactionType == TransactionType.DELIVERY
                              ? defaultAddress
                              : null,
                          transactionType: _transactionType,
                          schedule: _schedule,
                          customer: customer,
                        )
                      ]),
                    )
                  ],
                ),
              );
            } else {
              return const Text('No data available.');
            }
          }),
    );
  }
}

class OrderDetails extends StatefulWidget {
  List<OrderItems> orderList;
  TransactionType transactionType;
  TransactionSchedule schedule;
  num total = 0;
  num shipping = 0;
  String message;
  num totalWeight = 0;
  Function(int index, int value) changeQuantity;
  Function(String message) onMessageChange;
  OrderDetails(
      {super.key,
      required this.orderList,
      required this.transactionType,
      required this.schedule,
      required this.total,
      required this.shipping,
      required this.message,
      required this.totalWeight,
      required this.changeQuantity,
      required this.onMessageChange});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    _messageController.text = widget.message;
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
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
              itemCount: widget.orderList.length,
              itemBuilder: (context, index) {
                OrderItems orderItems = widget.orderList[index];
                return OrderItemContainer(
                  orderItems: orderItems,
                  changeQuantity: (value) {
                    widget.changeQuantity(index, value);
                  },
                  type: widget.transactionType,
                );
              }),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Column(
              children: [
                const Divider(),
                OrderDetailsData(
                    title: "Total items", value: "${widget.totalWeight}"),
                OrderDetailsData(
                    title: "Shipping Fee", value: formatPrice(widget.shipping)),
                OrderDetailsData(
                    title: widget.transactionType == TransactionType.DELIVERY
                        ? "Estimated Delivery Time"
                        : "Estimated Pick up Time",
                    value: widget.schedule.getFormatedSchedule()),
                OrderDetailsData(
                    title: "Sub Total", value: formatPrice(widget.total))
              ],
            ),
          ),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Message",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400],
                ),
              ),
              Expanded(
                child: TextField(
                  onSubmitted: (value) {
                    widget.onMessageChange(value);
                  },
                  controller: _messageController,
                  textAlign: TextAlign.end,
                  decoration: const InputDecoration(
                    hintText: 'Please leave a message',
                    hintTextDirection: TextDirection.ltr,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.red,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
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
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final Address? address;
  final String uid;
  TransactionType type;

  ShippingDetails(
      {Key? key, required this.address, required this.uid, required this.type})
      : super(key: key);

  Widget displayAddress(BuildContext context) {
    if (address == null) {
      return TextButton(
        onPressed: () {
          context.push('/address/$uid');
        },
        child: const Text("Add Address"),
      );
    }
    return Column(
      children: [
        Row(
          children: [
            Text(
              truncateText(address!.contact.name, 20),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              " | ${address!.contact.phone}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        Text(
          truncateText(address!.getFormattedLocation(), 40),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset("lib/assets/images/from.png"),
            title: Text(
              type == TransactionType.DELIVERY ? "From" : "Pick up from",
              style: TextStyle(color: Colors.grey[400]),
            ),
            subtitle: const Text(
              "Belmonte St., 2428 Urdaneta, Pangasinan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          if (type == TransactionType.DELIVERY)
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
          if (type == TransactionType.DELIVERY)
            ListTile(
              enabled: type == TransactionType.DELIVERY,
              contentPadding: EdgeInsets.zero,
              leading: Image.asset("lib/assets/images/loc.png"),
              title: const Text("To"),
              subtitle: displayAddress(context),
              trailing: IconButton(
                onPressed: () {
                  context.push('/address/$uid');
                },
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ),
        ],
      ),
    );
  }
}

class PaymentTypeToggle extends StatelessWidget {
  final TransactionType transactionType;
  Function(int type) paymentMethod;
  List<bool> isSelected;
  PaymentTypeToggle(
      {required this.transactionType,
      required this.paymentMethod,
      required this.isSelected});

  // Initialize the selection values
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ToggleButtons(
        direction: Axis.vertical,
        isSelected: isSelected,
        onPressed: (int index) {
          if (!isButtonDisabled(index)) {
            paymentMethod(index);
            for (int buttonIndex = 0;
                buttonIndex < isSelected.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                isSelected[buttonIndex] = true;
              } else {
                isSelected[buttonIndex] = false;
              }
            }
          }
        },
        selectedBorderColor: Colors.transparent,
        borderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        disabledColor: Colors.grey,
        children:
            _buildToggleButtonsChildren(), // Specify the color for disabled buttons
      ),
    );
  }

  bool isButtonDisabled(int index) {
    if (transactionType == TransactionType.DELIVERY) {
      if (index == 2) {
        return true;
      }
    }
    if (transactionType == TransactionType.PICK_UP) {
      if (index == 0) {
        return true;
      }
    }
    // You can customize the logic based on your specific use case
    return false;
  }

  List<Widget> _buildToggleButtonsChildren() {
    // Build the list of children with conditional text styling
    final List<Widget> children = [
      _buildToggleButtonsChild(0, 'COD'),
      _buildToggleButtonsChild(1, 'GCASH'),
      _buildToggleButtonsChild(2, 'PAY IN COUNTER'),
    ];

    return children;
  }

  Widget _buildToggleButtonsChild(int index, String text) {
    // Build a single child with conditional text styling
    final bool disabled = isButtonDisabled(index);
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: disabled
              ? Colors.grey
              : Colors.black, // Text color is grey when disabled
        ),
      ),
    );
  }
}

class CheckoutActions extends StatefulWidget {
  final String customerID;
  final List<OrderItems> orderList;
  final Details details;
  final Payment payment;
  final ShippingFee? shippingFee;
  final String message;
  final Address? address;
  final TransactionType transactionType;
  final TransactionSchedule schedule;
  final Customer customer;
  const CheckoutActions(
      {super.key,
      required this.customerID,
      required this.orderList,
      required this.details,
      required this.payment,
      this.address,
      this.shippingFee,
      required this.message,
      required this.transactionType,
      required this.schedule,
      required this.customer});

  @override
  State<CheckoutActions> createState() => _CheckoutActionsState();
}

class _CheckoutActionsState extends State<CheckoutActions> {
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

  @override
  Widget build(BuildContext context) {
    print('${areAllItemsAboveMinimum(widget.orderList)}');
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
            if (widget.payment.type == PaymentType.GCASH) {
              context.push('/gcash-payment', extra: {
                'transactionID': state.data,
                'payment': jsonEncode(widget.payment),
                'customer': widget.customer.name
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
                      if (countOrders(widget.orderList) < 50) {
                        if (areAllItemsAboveMinimum(widget.orderList) ==
                                false &&
                            widget.transactionType ==
                                TransactionType.DELIVERY) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Order is less than the minimum requirements")));
                          return;
                        }
                      }
                      if (widget.transactionType == TransactionType.DELIVERY &&
                          widget.address == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please add address")));
                        return;
                      }
                      placeOrder(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorStyle.brandRed,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          widget.payment.type == PaymentType.GCASH
                              ? "Next"
                              : "Place order",
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

  void placeOrder(BuildContext context) {
    context.read<TransactionsBloc>().add(
          CreateTransactionEvent(
            widget.customerID,
            widget.orderList,
            widget.details,
            widget.payment,
            widget.shippingFee,
            widget.message,
            widget.transactionType,
            widget.schedule,
            widget.address,
          ),
        );
  }
}
