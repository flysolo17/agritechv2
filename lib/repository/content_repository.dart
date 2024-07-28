import 'dart:async';

import 'package:agritechv2/models/cms/Topic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cms/TopicSubject.dart';

const SUBJECT_COLLECTION = "subjects";
const TOPIC_COLLECTION = "pest";
const CONTENT_COLLECTION = "contents";

class ContentRepository {
  final FirebaseFirestore _firebaseFirestore;

  ContentRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance {}

  Stream<List<TopicSubject>> getAllTopicSubject() {
    final controller = StreamController<List<TopicSubject>>();
    Future.delayed(const Duration(seconds: 1), () {
      _firebaseFirestore
          .collection(SUBJECT_COLLECTION)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        final list =
            snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return TopicSubject.fromFirestore(doc);
        }).toList();
        controller.add(list);
      });
    });
    return controller.stream;
  }

  Stream<List<Topic>> getAllTopics(String subjectID) {
    final controller = StreamController<List<Topic>>();
    Future.delayed(const Duration(seconds: 1), () {
      _firebaseFirestore
          .collection(TOPIC_COLLECTION)
          .where('subjectID', isEqualTo: subjectID)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        final list =
            snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return Topic.fromFirestore(doc);
        }).toList();
        controller.add(list);
      });
    });
    return controller.stream;
  }
}