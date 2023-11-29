import 'package:agritechv2/models/transaction/TransactionStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Details {
  String updatedBy;
  String message;
  TransactionStatus status;
  DateTime updatedAt;
  Details({
    required this.updatedBy,
    required this.message,
    required this.status,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'updatedBy': updatedBy,
      'message': message,
      'status': status.toString().split('.').last, // Convert enum to string
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      updatedBy: json['updatedBy'],
      message: json['message'],
      status: TransactionStatus.values.firstWhere((e) =>
          e.toString().split('.').last ==
          json['status']), // Convert string to enum
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }
}
