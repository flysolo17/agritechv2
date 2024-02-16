import 'dart:ffi';

import 'package:agritechv2/models/users/Users.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/messages.dart';

class MessagesRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String COLLECTION_NAME = 'messages';
  final String COLLECTION_USERS = 'users';
  MessagesRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Users>> getAllUsers() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firebaseFirestore
              .collection(COLLECTION_USERS)
              .where('type', whereIn: ['staff', 'admin']).get();
      await Future.delayed(const Duration(seconds: 1));
      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return Users(
          id: doc.id,
          name: doc['name'],
          phone: doc['phone'],
          profile: doc['profile'],
          type: doc['type'],
          email: doc['email'],
          address: doc['address'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<Users> getUserInfo(String userId) async {
    print('Getting user data from Cloud Firestore');
    var snapshot = await _firebaseFirestore
        .collection(COLLECTION_USERS)
        .doc(userId)
        .get()
        .catchError((err) => {print("getUserInfo $err")});

    return Users.fromJson(snapshot);
  }

  Stream<List<Messenger>> getMyMessages(String myID) {
    try {
      final q = _firebaseFirestore
          .collection(COLLECTION_NAME)
          .where(Filter.or(Filter("senderID", isEqualTo: myID),
              Filter("receiverID", isEqualTo: myID)))
          .orderBy('createdAt', descending: true);
      return q.snapshots().map((QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return Messenger.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Error fetching messages: $e');
      throw e;
    }
  }

  Stream<List<Messenger>> getConversation(String customerID, String staffID) {
    try {
      String id = customerID + staffID;
      print("CONVO ID $id");
      return _firebaseFirestore
          .collection(COLLECTION_NAME)
          .where('id', isEqualTo: id)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
        print("Messages : ${snapshot.docs.length}");
        return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return Messenger.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Error fetching messages: $e');
      throw e;
    }
  }

  void sendMessage(Messenger messenger) async {
    messenger.id = messenger.senderID + messenger.receiverID;
    _firebaseFirestore.collection(COLLECTION_NAME).add(messenger.toJson());
  }
}
