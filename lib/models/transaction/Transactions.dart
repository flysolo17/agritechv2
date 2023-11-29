import 'package:agritechv2/models/Address.dart';
import 'package:agritechv2/models/transaction/OrderItems.dart';
import 'package:agritechv2/models/transaction/PaymentMethod.dart';
import 'package:agritechv2/models/transaction/ShippingFee.dart';
import 'package:agritechv2/models/transaction/TransactionSchedule.dart';
import 'package:agritechv2/models/transaction/TransactionType.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TransactionDetails.dart';
import 'TransactionStatus.dart';

class Transactions {
  String id;
  String customerID;
  String cashierID;
  TransactionType type;
  List<OrderItems> orderList;
  String message;
  TransactionStatus status;
  Payment payment;
  List<Details> details;
  ShippingFee? shippingFee;
  Address? address;
  DateTime createdAt;
  TransactionSchedule? schedule;
  Transactions({
    required this.id,
    required this.customerID,
    required this.cashierID,
    required this.type,
    required this.orderList,
    required this.message,
    required this.status,
    required this.details,
    required this.payment,
    this.shippingFee,
    this.address,
    required this.createdAt,
    this.schedule,
  });

  Payment getTotalPayment(
    TransactionType type,
    List<OrderItems> orderList,
    PaymentType paymentType,
  ) {
    num shippingFee = type == TransactionType.DELIVERY
        ? computeTotalShippingFee(orderList)
        : 0;
    num productTotal = computeTotalOrderCost(orderList);
    num total = productTotal + shippingFee;
    Payment payment =
        Payment(amount: total, type: paymentType, status: PaymentStatus.UNPAID);
    return payment;
  }

  num computeTotalShippingFee(List<OrderItems> orderItems) {
    num totalShippingFee = 0;
    for (OrderItems item in orderItems) {
      totalShippingFee += item.shippingInfo.shipping;
    }
    return totalShippingFee;
  }

  num computeTotalOrderCost(List<OrderItems> orderItems) {
    num totalOrderCost = 0;
    for (OrderItems item in orderItems) {}

    return totalOrderCost;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerID': customerID,
      'cashierID': cashierID,
      'type': type.toString().split('.').last,
      'orderList': orderList.map((item) => item.toJson()).toList(),
      'message': message,
      'status': status.toString().split('.').last,
      'details': details.map((detail) => detail.toJson()).toList(),
      'payment': payment.toJson(),
      'shippingFee': shippingFee?.toJson(),
      'address': address?.toJson(),
      'createdAt': createdAt.toUtc(),
      'schedule': schedule?.toJson(),
    };
  }

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
        id: json['id'],
        customerID: json['customerID'],
        cashierID: json['cashierID'],
        type: TransactionType.values.firstWhere(
            (element) => element.toString().split(".").last == json['type']),
        orderList: (json['orderList'] as List)
            .map((item) => OrderItems.fromJson(item))
            .toList(),
        message: json['message'],
        status: TransactionStatus.values.firstWhere((e) =>
            e.toString().split('.').last ==
            json['status']), // Convert string to enum
        details: (json['details'] as List)
            .map((detail) => Details.fromJson(detail))
            .toList(),
        payment: Payment.fromJson(json['payment']),
        shippingFee: json['shippingFee'] != null
            ? ShippingFee.fromJson(json['shippingFee'])
            : null,
        address:
            json['address'] != null ? Address.fromJson(json['address']) : null,
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        schedule: json['schedule'] != null
            ? TransactionSchedule.fromJson(json['schedule'])
            : null);
  }
}
