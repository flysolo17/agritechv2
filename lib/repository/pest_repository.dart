import 'dart:async';

import 'package:agritechv2/models/pest/pest_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PestRepository {
  final FirebaseFirestore _firebaseFirestore;
  static const String COLLECTION_NAME = 'pest_map';

  PestRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance {}

  Stream<List<PestMap>> getAllPestMap(String topic) {
    return _firebaseFirestore
        .collection(COLLECTION_NAME)
        .where('topic', isEqualTo: topic)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return PestMap.fromJson(doc.data() ?? {});
      }).toList();
    });
  }
}
