import 'package:agritechv2/models/transaction/Transactions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../styles/color_styles.dart';

class RatingPage extends StatelessWidget {
  final Transactions transactions;
  const RatingPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate the product and service"),
        backgroundColor: ColorStyle.brandRed,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [Text(transactions.id)],
      ),
    );
  }
}
