import 'package:flutter/material.dart';

class OrderDetailsData extends StatelessWidget {
  final String title;
  final String value;
  double? textSize;
  OrderDetailsData(
      {super.key, required this.title, required this.value, this.textSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: textSize ?? 12, color: Colors.black),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: textSize ?? 14,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
