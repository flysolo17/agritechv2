import 'package:agritechv2/models/transaction/OrderItems.dart';
import 'package:agritechv2/models/transaction/Transactions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../styles/color_styles.dart';

class RatingPage extends StatelessWidget {
  final Transactions transactions;
  const RatingPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate"),
        backgroundColor: ColorStyle.brandRed,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(transactions.id),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.orderList.length,
              itemBuilder: (context, index) {
                return ProductRatingCard(
                    orderItems: transactions.orderList[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductRatingCard extends StatefulWidget {
  final OrderItems orderItems;

  const ProductRatingCard({Key? key, required this.orderItems})
      : super(key: key);

  @override
  State<ProductRatingCard> createState() => _ProductRatingCardState();
}

class _ProductRatingCardState extends State<ProductRatingCard> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;

  void _submitRating() {
    print('Rating: $_rating');
    print('Comment: ${_commentController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            widget.orderItems.imageUrl,
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.orderItems.productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  TextField(
                    controller: _commentController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Add a comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitRating,
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
