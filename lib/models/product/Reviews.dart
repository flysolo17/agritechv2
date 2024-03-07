import 'package:agritechv2/models/product/Comments.dart';

class Reviews {
  String id;
  String productID;
  num rating;
  String message;
  String customerID;
  List<Comments> comments;
  Reviews({
    required this.id,
    required this.productID,
    required this.rating,
    required this.message,
    required this.customerID,
    required this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productID': productID,
      'rating': rating,
      'message': message,
      'customerID': customerID,
      'comments': comments.map((e) => e.toJson()).toList()
    };
  }

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
        id: json['id'],
        productID: json['productID'],
        rating: json['rating'],
        message: json['message'],
        customerID: json['customerID'],
        comments: List<Comments>.from(
            json['comments'].map((v) => Reviews.fromJson(v))));
  }
}
