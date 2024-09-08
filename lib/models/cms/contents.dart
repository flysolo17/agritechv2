import 'package:cloud_firestore/cloud_firestore.dart';

class Contents {
  String id;
  String title;
  String description;
  String image;

  bool show;
  DateTime createdAt;

  Contents({
    required this.id,
    required this.title,
    required this.description,
    required this.image,

    required this.show,
    required this.createdAt,
  });

  factory Contents.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data()!;
    return Contents(
      id: data['id'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      image: data['image'] as String,
 
      show: data['show'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,

      'show': show,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
