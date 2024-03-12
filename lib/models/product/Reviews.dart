import 'package:agritechv2/models/product/Comments.dart';

class Reviews {
  String id;
  String transactionID;
  String productID;
  num rating;
  String message;
  String customerID;

  List<Comments> comments;
  DateTime createdAt;
  Reviews({
    required this.id,
    required this.transactionID,
    required this.productID,
    required this.rating,
    required this.message,
    required this.customerID,
    required this.comments,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionID': transactionID,
      'productID': productID,
      'rating': rating,
      'message': message,
      'customerID': customerID,
      'comments': comments.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Reviews.fromJson(String docID, Map<String, dynamic> json) {
    return Reviews(
      id: json['id'],
      transactionID: json['transactionID'],
      productID: json['productID'],
      rating: json['rating'],
      message: json['message'],
      customerID: json['customerID'],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comments.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
