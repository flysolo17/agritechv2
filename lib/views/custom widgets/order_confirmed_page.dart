import 'package:agritechv2/views/custom%20widgets/button.dart';
import 'package:flutter/material.dart';

class OrderConfirmPage extends StatelessWidget {
  Function onTap;
  OrderConfirmPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("lib/assets/images/confirm.png"),
            const Text(
              "Your order has been confirmed",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            Button(
              buttonText: "Continue Shopping",
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
