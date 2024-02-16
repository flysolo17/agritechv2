import 'package:cloud_firestore/cloud_firestore.dart';

class Messenger {
  String id;
  final String senderID;
  final String receiverID;
  final Role role;
  final String message;
  final bool seen;
  final DateTime createdAt;

  Messenger({
    required this.id,
    required this.senderID,
    required this.receiverID,
    required this.role,
    required this.message,
    required this.seen,
    required this.createdAt,
  });

  factory Messenger.fromJson(Map<String, dynamic> json) {
    return Messenger(
      id: json['id'] as String,
      senderID: json['senderID'] as String,
      receiverID: json['receiverID'] as String,
      role: Role.values
          .firstWhere((e) => e.toString().split('.').last == json['role']),
      message: json['message'] as String,
      seen: json['seen'] as bool,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderID': senderID,
      'receiverID': receiverID,
      'role': role.toString().split('.').last,
      'message': message,
      'seen': seen,
      'createdAt': createdAt.toUtc(),
    };
  }

  @override
  String toString() {
    return 'Messages{id: $id, senderID: $senderID, receiverID: $receiverID, role: $role, createdAt: $createdAt}';
  }
}

enum Role { CUSTOMER, STAFF }
