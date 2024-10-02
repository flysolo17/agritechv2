import 'dart:io';

import 'package:agritechv2/models/Address.dart';
import 'package:agritechv2/models/transaction/ShippingFee.dart';
import 'package:agritechv2/models/transaction/TransactionSchedule.dart';
import 'package:agritechv2/models/transaction/TransactionType.dart';
import 'package:agritechv2/utils/Constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:heif_converter/heif_converter.dart';

import '../models/transaction/OrderItems.dart';
import '../models/transaction/PaymentMethod.dart';
import '../models/transaction/TransactionDetails.dart';
import '../models/transaction/TransactionStatus.dart';
import '../models/transaction/Transactions.dart';

class TransactionRepostory {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String COLLECTION_NAME = 'transactions';
  TransactionRepostory({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Future<void> submitTransaction(Transactions transaction) async {
    transaction.id = generateInvoiceID();
    try {
      await _firestore
          .collection(COLLECTION_NAME)
          .doc(transaction.id)
          .set(transaction.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> createTransaction(
    String transactionID,
    String customerID,
    List<OrderItems> orderList,
    Details details,
    Payment payment,
    ShippingFee? shippingFee,
    String message,
    TransactionType transactionType,
    TransactionSchedule schedule,
    Address? address,
  ) async {
    details.message = "Pending order";
    final Transactions transaction = Transactions(
      id: transactionID,
      customerID: customerID,
      driverID: '',
      cashierID: "",
      type: transactionType,
      orderList: orderList,
      message: message,
      status: TransactionStatus.PENDING,
      details: [details],
      payment: payment,
      shippingFee: shippingFee,
      address: address,
      createdAt: DateTime.now(),
      schedule: schedule,
    );

    try {
      await _firestore
          .collection(COLLECTION_NAME)
          .doc(transaction.id)
          .set(transaction.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<File?> downloadAndConvert(File heicFile) async {
    final resultPath =
        await HeifConverter.convert(heicFile.path, format: 'png');
    if (resultPath != null) {
      return File(resultPath);
    }
    return null;
  }

  Future<String?> uploadTransactionAttachment(File file) async {
    try {
      if (file.path.split('.').last == 'heic') {
        final convertedFile = await downloadAndConvert(file);
        if (convertedFile != null) {
          file = convertedFile;
        } else {
          throw Exception("Failed to convert HEIC file.");
        }
      }
      final extension = file.path.split('.').last;
      final fileName = '${generateInvoiceID()}.$extension';
      final storageRef = _storage.ref().child(COLLECTION_NAME).child(fileName);
      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> cancelTrancsaction(
      String transactionID, String name, String message) async {
    final Details details = Details(
        updatedBy: name,
        message: message,
        status: TransactionStatus.CANCELLED,
        updatedAt: DateTime.now());
    return _firestore.collection(COLLECTION_NAME).doc(transactionID).update({
      'status': TransactionStatus.CANCELLED.name,
      'details': FieldValue.arrayUnion([details.toJson()])
    }).catchError((err) => {print('transactions : ${err}')});
  }

  Future<List<Transactions>> getTransactionsByStatus(
      TransactionStatus status, String customerID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(COLLECTION_NAME)
          .where("customerID", isEqualTo: customerID)
          .where("status", isEqualTo: status.name)
          .orderBy("createdAt", descending: false)
          .get()
          .catchError((err) => List.empty());

      List<Transactions> transactions = querySnapshot.docs
          .map((doc) =>
              Transactions.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return transactions;
    } catch (error) {
      print('Error fetching transactions: $error');
      rethrow;
    }
  }

  Future<Transactions> getTransactionsByID(String transactionID) async {
    try {
      final documentSnapshot =
          await _firestore.collection(COLLECTION_NAME).doc(transactionID).get();

      if (documentSnapshot.exists) {
        final tran = documentSnapshot.data() as Map<String, dynamic>;
        final transaction = Transactions.fromJson(tran);
        return transaction;
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      print("Error fetching product: ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> gcashPayment(String transactionID, Payment payment) async {
    DocumentReference docRef =
        _firestore.collection(COLLECTION_NAME).doc(transactionID);
    await docRef.update(
      {
        'payment': payment.toJson(),
      },
    );
  }

  Future<int> computeProductsSold(String productID) async {
    int productsSold = 0;

    CollectionReference transactionsCollection =
        _firestore.collection(COLLECTION_NAME);

    QuerySnapshot transactionsSnapshot = await transactionsCollection.get();

    for (var transactionDoc in transactionsSnapshot.docs) {
      List<dynamic> orderListData = transactionDoc['orderList'];
      for (var orderItemData in orderListData) {
        String productId = orderItemData['productID'];
        int quantity = orderItemData['quantity'];
        if (productId == productID) {
          productsSold += quantity;
        }
      }
    }

    return productsSold;
  }
}
