import 'package:agritechv2/models/transaction/TransactionType.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DeliveryOptions extends StatefulWidget {
  final TransactionType type;
  final Function(TransactionType type) onTypeChange;
  const DeliveryOptions(
      {super.key, required this.type, required this.onTypeChange});

  @override
  State<DeliveryOptions> createState() => _DeliveryOptionsState();
}

class _DeliveryOptionsState extends State<DeliveryOptions> {
  int index = 0;
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
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Delivery Options",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          ToggleSwitch(
            initialLabelIndex: widget.type == TransactionType.DELIVERY ? 0 : 1,
            totalSwitches: 2,
            isVertical: true,
            minWidth: double.infinity,
            minHeight: 60,
            customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
            labels: const ['DELIVERY', 'PICK UP'],
            inactiveBgColor: Colors.white,
            activeBgColor: [Colors.blue[100] ?? Colors.blue],
            iconSize: 34,
            centerText: true,
            customIcons: [
              Icon(
                Icons.local_shipping_outlined,
                color: index == 0 ? Colors.white : Colors.black,
              ),
              Icon(
                Icons.warehouse,
                color: index == 1 ? Colors.white : Colors.black,
              ),
            ],
            onToggle: (index) {
              widget.onTypeChange(index == 0
                  ? TransactionType.DELIVERY
                  : TransactionType.PICK_UP);
              setState(() {
                this.index = index ?? 0;
              });
              print('switched to: $index');
            },
          ),
        ],
      ),
    );
  }
}
