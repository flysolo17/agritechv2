import 'package:cloud_firestore/cloud_firestore.dart';

class PestMap {
  String id;
  String title;
  String image;
  List<Topic> topic;
  DateTime createdAt;

  PestMap({
    required this.id,
    required this.title,
    required this.image,
    required this.topic,
    required this.createdAt,
  });

  factory PestMap.fromJson(Map<String, dynamic> json) {
    return PestMap(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      topic: (json['topic'] as List<dynamic>)
          .map((topicJson) => Topic.fromJson(topicJson))
          .toList(),
      createdAt: (json['createdAt'] is String)
          ? DateTime.parse(json['createdAt']) // Convert string to DateTime
          : (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'topic': topic.map((topic) => topic.toJson()).toList(),
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }
}

class Topic {
  String title;
  String desc;
  String image;
  String category;
  List<Contents> contents;
  List<Comments> comments;
  List<String> recomendations;

  Topic({
    required this.title,
    required this.desc,
    required this.image,
    required this.category,
    required this.contents,
    required this.comments,
    required this.recomendations,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      title: json['title'],
      desc: json['desc'],
      image: json['image'],
      category: json['category'],
      contents: (json['contents'] as List<dynamic>)
          .map((contentsJson) => Contents.fromJson(contentsJson))
          .toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((commentsJson) => Comments.fromJson(commentsJson))
          .toList(),
      recomendations: (json['recomendations'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'image': image,
      'category': category,
      'contents': contents.map((contents) => contents.toJson()).toList(),
      'comments': comments.map((comments) => comments.toJson()).toList(),
      'recomendations': recomendations,
    };
  }
}

class Contents {
  String title;
  String description;
  String image;

  Contents({
    required this.title,
    required this.description,
    required this.image,
  });

  factory Contents.fromJson(Map<String, dynamic> json) {
    return Contents(
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
    };
  }
}

class Comments {
  String userID;
  bool isAgritechEmployee;
  String comment;

  Comments({
    required this.userID,
    required this.isAgritechEmployee,
    required this.comment,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      userID: json['userID'],
      isAgritechEmployee: json['isAgritechEmployee'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'isAgritechEmployee': isAgritechEmployee,
      'comment': comment,
    };
  }
}
