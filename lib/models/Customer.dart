import 'package:agritechv2/models/Address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  Customer({
    required this.id,
    required this.profile,
    required this.name,
    required this.email,
    required this.phone,
    required this.addresses, // Add the addresses field
  });

  String id;
  String profile;
  String name;
  String email;
  String phone;
  List<Address> addresses;
  Customer copyWith({
    String? id,
    String? profile,
    String? name,
    String? email,
    String? phone,
    List<Address>? addresses,
  }) {
    return Customer(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      addresses: addresses ?? this.addresses,
    );
  }

  Address? getDefaultAddress() {
    Address? address;
    try {
      address = addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return null;
    }
    return address;
  }
  factory Customer.fromJson(DocumentSnapshot snap) {
    final List<dynamic> addressesData = snap['addresses'] ?? [];

    final List<Address> parsedAddresses = addressesData.map((addressData) {
      final Contact contact = Contact.fromJson(addressData['contact']);
      return Address(
          region: addressData['region'],
          province: addressData['province'],
          city: addressData['city'],
          barangay: addressData['barangay'],
          postalCode: addressData['postalCode'],
          landmark: addressData['landmark'],
          addressType: addressData['addressType'] == 'work'
              ? AddressType.work
              : AddressType.home,
          contact: contact,
          isDefault: addressData['isDefault']);
    }).toList();

    return Customer(
      id: snap.id,
      profile: snap['profile'],
      name: snap['name'],
      email: snap['email'],
      phone: snap['phone'],
      addresses: parsedAddresses,
    );
  }

  Map<String, Object> toJson() {
    final List<Map<String, Object>> addressesData = addresses.map((address) {
      // Get the JSON representation of the contact object
      final Map<String, dynamic> contactData = address.contact.toJson();

      return {
        'region': address.region,
        'province': address.province,
        'city': address.city,
        'barangay': address.barangay,
        'postalCode': address.postalCode,
        'landmark': address.landmark,
        'addressType': address.addressType.toString().split('.').last,
        'contact': contactData,
        'isDefault': address.isDefault,
      };
    }).toList();

    return {
      'profile': profile,
      'name': name,
      'email': email,
      'phone': phone,
      'addresses': addressesData,
    };
  }

  // ignore: constant_identifier_names
  static const String TABLE_NAME = 'customers';
}
