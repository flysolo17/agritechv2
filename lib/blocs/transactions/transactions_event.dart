part of 'transactions_bloc.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

class CreateTransactionEvent extends TransactionsEvent {
  final String customerID;
  final List<OrderItems> orderList;

  final Details details;
  final Payment payment;
  final ShippingFee? shippingFee;
  final String message;
  final TransactionType transactionType;
  final TransactionSchedule schedule;
  final Address? address;
  const CreateTransactionEvent(
      this.customerID,
      this.orderList,
      this.details,
      this.payment,
      this.shippingFee,
      this.message,
      this.transactionType,
      this.schedule,
      this.address);
  @override
  List<Object?> get props =>
      [customerID, orderList, details, payment, shippingFee, message, address];
}

class UploadTransactionAttachment extends TransactionsEvent {
  final File file;
  const UploadTransactionAttachment(this.file);
  @override
  List<Object> get props => [file];
}

class GetTransactionsByStatus extends TransactionsEvent {
  final TransactionStatus status;
  final String customerID;
  const GetTransactionsByStatus(this.status, this.customerID);

  @override
  List<Object> get props => [status, customerID];
}

class CancelTransactionEvent extends TransactionsEvent {
  final String transactionID;
  final String name;
  final String message;
  const CancelTransactionEvent(this.transactionID, this.name, this.message);

  @override
  List<Object> get props => [transactionID, name, message];
}

class AddGcashPayment extends TransactionsEvent {
  final File file;
  final String customerName;
  final String transactionID;
  final Payment payment;
  const AddGcashPayment(
      this.file, this.customerName, this.transactionID, this.payment);

  @override
  List<Object> get props =>
      [transactionID, customerName, transactionID, payment];
}
