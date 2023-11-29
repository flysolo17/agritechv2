class Address {
  String region;
  String province;
  String city;
  String barangay;
  String postalCode;
  String landmark;
  AddressType addressType;
  Contact contact;
  bool isDefault;
  Address({
    required this.region,
    required this.province,
    required this.city,
    required this.barangay,
    required this.postalCode,
    required this.landmark,
    required this.addressType,
    required this.contact,
    required this.isDefault,
  });

  String getFormattedLocation() {
    return '$barangay, $city ,$province, $region, $postalCode';
  }

  Map<String, dynamic> toJson() {
    return {
      'region': region,
      'province': province,
      'city': city,
      'barangay': barangay,
      'postalCode': postalCode,
      'landmark': landmark,
      'addressType': addressType.toString().split('.').last,
      'contact': contact.toJson(),
      'isDefault': isDefault,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        region: json['region'],
        province: json['province'],
        city: json['city'],
        barangay: json['barangay'],
        postalCode: json['postalCode'],
        landmark: json['landmark'],
        addressType:
            json['addressType'] == 'work' ? AddressType.work : AddressType.home,
        contact: Contact.fromJson(json['contact']),
        isDefault: json['isDefault']);
  }
}

enum AddressType {
  home,
  work,
}

class Contact {
  String name;
  String phone;

  Contact({
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phone: json['phone'],
    );
  }
}
