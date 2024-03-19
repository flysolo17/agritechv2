import 'package:agritechv2/models/transaction/TransactionType.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../models/transaction/PaymentMethod.dart';

class PaymentMethods extends StatelessWidget {
  final TransactionType transactionType;

  Function(int type) paymentMethod;
  List<bool> isSelected;
  PaymentMethods(
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
