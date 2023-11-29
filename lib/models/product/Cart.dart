class Cart {
  String id;
  String userID;
  String productID;
  String variationID;
  bool isVariation;
  int quantity;
  DateTime createdAt;

  Cart({
    required this.id,
    required this.userID,
    required this.productID,
    required this.variationID,
    required this.isVariation,
    required this.quantity,
    required this.createdAt,
  });

  // Create an instance from a Map (Deserialization)
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userID: json['userID'],
      productID: json['productID'],
      variationID: json['variationID'],
      isVariation: json['isVariation'],
      quantity: json['quantity'],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Convert an instance to a Map (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'productID': productID,
      'variationID': variationID,
      'isVariation': isVariation,
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
