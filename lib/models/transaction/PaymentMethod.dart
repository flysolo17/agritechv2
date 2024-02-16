import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  num amount;
  PaymentType type;
  PaymentStatus status;
  PaymentDetails? details;

  Payment({
    required this.amount,
    required this.type,
    required this.status,
    this.details,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount: json['amount'] as num,
      type: PaymentType.values
          .firstWhere((e) => e.toString().split('.').last == json['type']),
      status: PaymentStatus.values
          .firstWhere((e) => e.toString().split('.').last == json['status']),
      details: json['details'] != null
          ? PaymentDetails.fromJson(json['details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'details': details?.toJson(),
    };
  }
}

enum PaymentType { COD, GCASH, PAY_IN_COUNTER }

enum PaymentStatus { UNPAID, PAID }

class PaymentDetails {
  String confirmedBy;
  String reference;
  String attachmentURL;
  DateTime createdAt;

  PaymentDetails({
    required this.confirmedBy,
    required this.reference,
    required this.attachmentURL,
    required this.createdAt,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      confirmedBy: json['confirmedBy'] as String,
      reference: json['reference'] as String,
      attachmentURL: json['attachmentURL'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'confirmedBy': confirmedBy,
      'reference': reference,
      'attachmentURL': attachmentURL,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
