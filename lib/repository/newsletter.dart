import 'dart:async';

import 'package:agritechv2/models/newsletter/Newsletter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsletterRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String COLLECTION_NAME = 'newsletters';
  NewsletterRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<NewsLetter>> getNewsletter() {
    final controller = StreamController<List<NewsLetter>>();
    Future.delayed(const Duration(seconds: 1), () {
      _firebaseFirestore
          .collection(COLLECTION_NAME)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        final list =
            snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return NewsLetter.fromMap(doc.data() ?? {});
        }).toList();
        controller.add(list);
      });
    });
    return controller.stream;
  }
}
