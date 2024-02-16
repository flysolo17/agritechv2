class Favorites {
  String id;
  final String productID;
  final String customerID;
  final DateTime createdAt;

  Favorites({
    required this.id,
    required this.productID,
    required this.customerID,
    required this.createdAt,
  });

  factory Favorites.fromJson(Map<String, dynamic> json) {
    return Favorites(
      id: json['id'] as String,
      productID: json['productID'] as String,
      customerID: json['customerID'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productID': productID,
      'customerID': customerID,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
