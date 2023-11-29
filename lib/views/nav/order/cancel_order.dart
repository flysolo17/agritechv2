import 'package:agritechv2/blocs/transactions/transactions_bloc.dart';
import 'package:agritechv2/repository/transaction_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/transaction/OrderItems.dart';
import '../../../models/transaction/Transactions.dart';
import '../../../utils/Constants.dart';

class OrderCancellationPage extends StatefulWidget {
  final Transactions transactions;
  const OrderCancellationPage({super.key, required this.transactions});

  @override
  State<OrderCancellationPage> createState() => _OrderCancellationPageState();
}

class _OrderCancellationPageState extends State<OrderCancellationPage> {
  TextEditingController _controller = TextEditingController();
  List<String> _reasons = [];
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionsBloc(
          transactionRepostory: context.read<TransactionRepostory>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cancelation Form"),
          backgroundColor: ColorStyle.brandRed,
        ),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.transactions.orderList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final OrderItems items =
                        widget.transactions.orderList[index];
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
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'What is the biggest reason for your wish to cancel ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    CancelationReasons(
                        onReasonsSelected: (List<String> reasons) {
                      _reasons = reasons;
                      print(reasons);
                    }),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(labelText: 'Message'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              BlocConsumer<TransactionsBloc, TransactionsState>(
                listener: (context, state) {
                  if (state is TransactionsFailedState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                  if (state is TransactionsSuccessState<String>) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.data)));
                    context.pop();
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return state is TransactionsLoadingState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorStyle.brandRed,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          onPressed: () {
                            String enteredText = _controller.text;
                            if (enteredText.isNotEmpty) {
                              _reasons.add(enteredText);
                            }
                            String reasonsString = _reasons.join(',\n');
                            context.read<TransactionsBloc>().add(
                                CancelTransactionEvent(
                                    widget.transactions.id,
                                    widget.transactions.details[0].updatedBy,
                                    reasonsString));
                          },
                          child: const Text(
                            'Confirm Cancellation',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CancelationReasons extends StatefulWidget {
  final Function(List<String>) onReasonsSelected;
  const CancelationReasons({super.key, required this.onReasonsSelected});

  @override
  State<CancelationReasons> createState() => _CancelationReasonsState();
}

class _CancelationReasonsState extends State<CancelationReasons> {
  List<String> cancellationReasons = [
    'Item Out of Stock',
    'Changed My Mind',
    'Found a Better Deal',
    'Shipping Delay',
  ];

  List<String> selectedReasons = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cancellationReasons.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(cancellationReasons[index]),
          value: selectedReasons.contains(cancellationReasons[index]),
          onChanged: (value) {
            setState(() {
              if (value!) {
                selectedReasons.add(cancellationReasons[index]);
              } else {
                selectedReasons.remove(cancellationReasons[index]);
              }
              widget.onReasonsSelected(selectedReasons);
            });
          },
        );
      },
    );
  }
}
