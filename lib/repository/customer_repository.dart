import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Customer.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore;
  static const String COLLECTION_NAME = 'customers';
  
  UserRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> createUser(Customer user) async {
    await _firebaseFirestore
        .collection(COLLECTION_NAME)
        .doc(user.id)
        .set(user.toJson());
  }

  Stream<Customer> getCustomer(String userId) {
    print('Getting user data from Cloud Firestore');
    return _firebaseFirestore
        .collection(COLLECTION_NAME)
        .doc(userId)
        .snapshots()
        .map((snap) => Customer.fromJson(snap));
  }

  Future<void> updateUser(Customer user) async {
    return _firebaseFirestore
        .collection(COLLECTION_NAME)
        .doc(user.id)
        .update(user.toJson())
        .then(
          (value) => print('User document updated.'),
        );
  }

}
