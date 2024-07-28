import 'package:agritechv2/models/product/Reviews.dart';
import 'package:agritechv2/models/product/Shipping.dart';
import 'package:agritechv2/models/product/Variations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  String id;
  List<String> images;
  String name;
  String description;
  String category;
  num cost;
  num price;
  int stocks;
  List<Variation> variations;
  DateTime expiryDate;
  List<Reviews> reviews;
  ShippingInfo shippingInformation;
  bool isHidden;
  bool featured;
  DateTime createdAt;

  Products({
    required this.id,
    required this.images,
    required this.name,
    required this.description,
    required this.category,
    required this.cost,
    required this.price,
    required this.stocks,
    required this.variations,
    required this.expiryDate,
    required this.reviews,
    required this.shippingInformation,
    required this.isHidden,
    required this.featured,
    required this.createdAt,
  });
  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      images: List<String>.from(json['images']),
      name: json['name'],
      description: json['description'],
      category: json['category'],
      cost: json['cost'],
      price: json['price'],
      stocks: json['stocks'],
      variations: List<Variation>.from(
          json['variations'].map((v) => Variation.fromJson(v))),
      expiryDate: (json['expiryDate'] as Timestamp).toDate(),
      reviews: [],
      shippingInformation: ShippingInfo.fromJson(json['shippingInformation']),
      isHidden: json['isHidden'],
      featured: json['featured'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
      'name': name,
      'description': description,
      'category': category,
      'cost': cost,
      'price': price,
      'stocks': stocks,
      'variations': variations.map((v) => v.toJson()).toList(),
      'expiryDate': expiryDate.toIso8601String(), // Convert to ISO 8601 string
      'reviews': variations.map((v) => v.toJson()).toList(),
      'shippingInformation': shippingInformation.toJson(),
      'isHidden': isHidden,
      'featured': featured,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Products(id: $id, name: $name, stocks: $stocks, price: $price)';
  }
}
