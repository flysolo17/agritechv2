import 'package:agritechv2/models/ReviewWithCustomer.dart';
import 'package:agritechv2/models/product/Reviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductRating extends StatelessWidget {
  final List<ReviewWithCustomer> reviews;
  const ProductRating({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index].reviews;
        final customer = reviews[index].customer;
        return ListTile(
          leading: customer?.profile != null || customer!.profile.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    customer!.profile,
                  ),
                )
              : const CircleAvatar(
                  child: Text('No Image'),
                ),
          title: Text(customer?.name ?? 'No name'),
          subtitle: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RatingBarIndicator(
                  rating: review.rating.toDouble(),
                  itemCount: 5,
                  itemSize: 10.0,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                Text(
                  review.message,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
