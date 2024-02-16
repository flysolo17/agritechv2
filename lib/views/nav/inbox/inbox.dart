import 'package:flutter/material.dart';

import '../../../styles/color_styles.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Inbox"),
          backgroundColor: ColorStyle.brandRed,
        ),
        backgroundColor: Colors.white,
        body: const Center(child: Text("No newsletter function yet")));
  }
}
