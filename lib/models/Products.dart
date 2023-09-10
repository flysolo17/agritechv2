// class Products {
//   String id;
//   String? image;
//   String name;
//   String category;
//   String description;
//   int quantity;
//   double cost;
//   double price;
//   int weight;
//   DateTime expiration;
//   DateTime createdAt;
//   DateTime? updatedAt;

//   Products(
//     this.id,
//     this.image,
//     this.name,
//     this.category,
//     this.description,
//     this.quantity,
//     this.cost,
//     this.price,
//     this.weight,
//     this.expiration,
//     this.createdAt,
//     this.updatedAt,
//   );

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'image': image,
//       'name': name,
//       'category': category,
//       'description': description,
//       'quantity': quantity,
//       'cost': cost,
//       'price': price,
//       'weight': weight,
//       'expiration': expiration.toIso8601String(),
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }

//   static Products fromJson(Map<String, dynamic> json) {
//     return Products(
//       json['id'],
//       json['image'],
//       json['name'],
//       json['category'],
//       json['description'],
//       json['quantity'],
//       json['cost'].toDouble(),
//       json['price'].toDouble(),
//       json['weight'],
//       json['expiration'].toDate(), // Convert Timestamp to DateTime
//       json['createdAt'].toDate(), // Convert Timestamp to DateTime
//       json['updatedAt'] != null
//           ? json['updatedAt'].toDate()
//           : null, // Convert Timestamp to DateTime
//     );
//   }
// }

import 'package:agritechv2/models/Variations.dart';

class Products {
  final String id;
  final String? image;
  final String name;
  final String category;
  final List<Variations> variations;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Products({
    required this.id,
    this.image,
    required this.name,
    required this.category,
    required this.variations,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      category: json['category'],
      variations: (json['variations'] as List<dynamic>)
          .map((variationJson) => Variations.fromJson(variationJson))
          .toList(),
      description: json['description'],
      createdAt: json['createdAt'].toDate(),
      updatedAt: json['updatedAt'] != null ? json['updatedAt'].toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'category': category,
      'variations': variations.map((variation) => variation.toJson()).toList(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
