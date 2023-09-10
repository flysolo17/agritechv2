import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  Customer(
      {required this.id,
      required this.profile,
      required this.name,
      required this.email,
      required this.phone});
  String id;
  String profile;
  String name;
  String email;
  String phone;

  Customer copyWith({
    String? id,
    String? profile,
    String? name,
    String? email,
    String? phone,
  }) {
    return Customer(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  factory Customer.fromJson(DocumentSnapshot snap) {
    return Customer(
      id: snap.id,
      profile: snap['profile'],
      name: snap['name'],
      email: snap['email'],
      phone: snap['phone'],
    );
  }

  Map<String, Object> toJson() {
    return {
      'profile': profile,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  String TABLE_NAME = 'customers';

  @override
  List<Object?> get props => [id, profile, name, email, phone];
}
