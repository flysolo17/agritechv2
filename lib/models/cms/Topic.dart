import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String id;
  String subjectID;
  String title;
  String desc;
  String image;
  List<String> recomendations;
  String category;
  DateTime createdAt;
  DateTime? updatedAt;

  Topic({
    required this.id,
    required this.subjectID,
    required this.title,
    required this.desc,
    required this.image,
    required this.category,
    required this.recomendations,
    required this.createdAt,
    this.updatedAt,
  });

  factory Topic.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data()!;
    return Topic(
      id: data['id'] as String,
      subjectID: data['subjectID'] as String,
      title: data['title'] as String,
      desc: data['desc'] as String,
      image: data['image'] as String,
      category: data['category'] as String,
      recomendations: List<String>.from(data['recomendations']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'subjectID': subjectID,
      'title': title,
      'desc': desc,
      'image': image,
      'category': category,
      'recomendations': recomendations,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
