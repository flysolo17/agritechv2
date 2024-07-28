import 'package:cloud_firestore/cloud_firestore.dart';

class TopicSubject {
  String id;
  String name;
  String cover;
  DateTime createdAt;

  TopicSubject({
    required this.id,
    required this.name,
    required this.cover,
    required this.createdAt,
  });

  factory TopicSubject.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data()!;
    return TopicSubject(
      id: data['id'] as String,
      name: data['name'] as String,
      cover: data['cover'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'cover': cover,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
