import 'dart:io';

import 'package:agritechv2/models/Address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/users/Customer.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore;
  static const String COLLECTION_NAME = 'customers';
  final FirebaseStorage _storage;

  UserRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? storage,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

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

  Future<Customer> getCustomerInfo(String userId) async {
    print('Getting user data from Cloud Firestore');
    var snapshot =
        await _firebaseFirestore.collection(COLLECTION_NAME).doc(userId).get();

    return Customer.fromJson(snapshot);
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

  Future<void> addAddress(String uid, List<Address> address) async {
    print(address);

    // Convert the list of Address objects to a List of Map objects
    List<Map<String, dynamic>> addressDataList =
        address.map((addr) => addr.toJson()).toList();

    return _firebaseFirestore
        .collection(COLLECTION_NAME)
        .doc(uid)
        .update({'addresses': addressDataList});
  }

  Future<void> updateUserPhoto(String userID, String photoURL) async {
    await _firebaseFirestore
        .collection(COLLECTION_NAME)
        .doc(userID)
        .update({'profile': photoURL});
  }

  Future<String?> uploadFile(File file) async {
    try {
      final Reference storageRef = _storage
          .ref()
          .child(COLLECTION_NAME)
          .child('${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = storageRef.putFile(file);
      await uploadTask.whenComplete(() => null);
      final imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> editProfile(String uid, String name) {
    return _firebaseFirestore
        .collection(COLLECTION_NAME)
        .doc(uid)
        .update({'name': name});
  }
}
