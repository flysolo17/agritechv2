import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String name;
  final String phone;
  final String profile;
  final String type;
  final String email;
  final String address;

  Users({
    required this.id,
    required this.name,
    required this.phone,
    required this.profile,
    required this.type,
    required this.email,
    required this.address,
  });

  factory Users.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    return Users(
      id: json['id'] as String ?? '',
      name: json['name'] as String ?? '',
      phone: json['phone'] as String ?? '',
      profile: json['profile'] as String ?? '',
      type: json['type'] as String ?? '',
      email: json['email'] as String ?? '',
      address: json['address'] as String ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'profile': profile,
      'type': type,
      'email': email,
      'address': address,
    };
  }
}
