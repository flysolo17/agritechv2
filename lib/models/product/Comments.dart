import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  String id;
  bool isCustomer;
  String customerID;
  String message;
  DateTime createdAt;

  Comments({
    required this.id,
    required this.isCustomer,
    required this.customerID,
    required this.message,
    required this.createdAt,
  });

  // Convert Comments object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isCustomer': isCustomer,
      'customerID': customerID,
      'message': message,
      'createdAt': createdAt.toUtc(),
    };
  }

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      isCustomer: json['isCustomer'],
      customerID: json['customerID'],
      message: json['message'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
