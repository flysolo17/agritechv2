import 'package:cloud_firestore/cloud_firestore.dart';

class NewsLetter {
  final String id;
  final String description;
  final String image;
  final DateTime createdAt;

  const NewsLetter({
    required this.id,
    required this.description,
    required this.image,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'NewsLetter{id: $id, description: $description, image: $image, createdAt: $createdAt}';
  }

  factory NewsLetter.fromMap(Map<String, dynamic> map) {
    return NewsLetter(
      id: map['id'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Method to convert the NewsLetter instance to a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'image': image,
      'createdAt': createdAt.toUtc(),
    };
  }
}
