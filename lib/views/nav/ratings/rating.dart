import 'package:agritechv2/models/product/Reviews.dart';
import 'package:agritechv2/models/transaction/OrderItems.dart';
import 'package:agritechv2/models/transaction/Transactions.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/review_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

import '../../../styles/color_styles.dart';
import '../../../utils/Constants.dart';

class RatingPage extends StatefulWidget {
  final Transactions transactions;

  const RatingPage({super.key, required this.transactions});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  List<Reviews> _reviews = [];

  @override
  void initState() {
    initReviews(widget.transactions.id);
    super.initState();
  }

  void initReviews(String transactionID) {
    context
        .read<ReviewRepository>()
        .getAllReviewByTransaction(transactionID)
        .listen((event) {
      setState(() {
        _reviews = event;
      });
    });
  }

  void showRatingModal(
      BuildContext context, OrderItems orderItems, Reviews? reviews) {
    final _formKey = GlobalKey<FormState>();
    double _rating = reviews?.rating.toDouble() ?? 0.0;
    String _review = reviews?.message ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Add Review',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Review',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your review';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _review = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Rating:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _rating = rating;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    color: ColorStyle.brandRed,
                    child: TextButton(
                      style: const ButtonStyle(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Reviews reviewsss = Reviews(
                              id: reviews?.id ?? generateInvoiceID(),
                              transactionID: widget.transactions.id,
                              productID: orderItems.productID,
                              rating: _rating,
                              message: _review,
                              customerID: context
                                      .read<AuthRepository>()
                                      .currentUser
                                      ?.uid ??
                                  '',
                              comments: List.empty(),
                              createdAt: DateTime.now());
                          context
                              .read<ReviewRepository>()
                              .createReview(reviewsss)
                              .then((value) => {
                                    context.pop(),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Rating success')))
                                  })
                              .catchError((err) => {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(err.toString())))
                                  });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.transactions.orderList.length,
              itemBuilder: (context, index) {
                return ProductRatingCard(
                  orderItems: widget.transactions.orderList[index],
                  reviews: _reviews
                      .where((review) =>
                          review.productID ==
                          widget.transactions.orderList[index].productID)
                      .toList(),
                  onTap: (items, message, reviews) =>
                      {showRatingModal(context, items, reviews)},
                  onDelete: (String id) => {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSold extends StatelessWidget {
  const ProductSold({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class ProductRatingCard extends StatelessWidget {
  final OrderItems orderItems;
  final List<Reviews> reviews;
  Function(OrderItems items, String message, Reviews? reviews) onTap;
  Function(String reviewID) onDelete;
  ProductRatingCard(
      {Key? key,
      required this.orderItems,
      required this.reviews,
      required this.onTap,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            leading: Image.network(
              orderItems.imageUrl,
              fit: BoxFit.cover,
              width: 100,
            ),
            title: Text(orderItems.productName),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatPrice(orderItems.price * orderItems.quantity),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "x${orderItems.quantity}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          ListTile(
            title:
                Text(reviews.isEmpty ? "No review yet!" : reviews[0].message),
            subtitle: RatingBarIndicator(
              rating: reviews.isEmpty ? 0.0 : reviews[0].rating.toDouble(),
              itemCount: 5,
              itemSize: 20.0,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
            ),
            trailing: IconButton.filledTonal(
                onPressed: () {
                  final current = reviews.isEmpty ? "" : reviews[0].message;
                  onTap(
                      orderItems, current, reviews.isEmpty ? null : reviews[0]);
                },
                icon: Icon(reviews.isEmpty ? Icons.add : Icons.edit)),
          )
        ],
      ),
    );
  }
}

// Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   widget.orderItems.productName,
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 RatingBar.builder(
  //                   initialRating: _rating,
  //                   minRating: 1,
  //                   direction: Axis.horizontal,
  //                   allowHalfRating: true,
  //                   itemCount: 5,
  //                   itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                   itemBuilder: (context, _) => const Icon(
  //                     Icons.star,
  //                     color: Colors.amber,
  //                   ),
  //                   onRatingUpdate: (rating) {
  //                     setState(() {
  //                       _rating = rating;
  //                     });
  //                   },
  //                 ),
  //                 TextField(
  //                   controller: _commentController,
  //                   maxLines: 2,
  //                   decoration: const InputDecoration(
  //                     labelText: 'Add a comment',
  //                     border: OutlineInputBorder(),
  //                   ),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: _submitRating,
  //                   child: const Text("Submit"),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
