class Variations {
  final String name;
  final int quantity;
  final int weight;
  final DateTime expiration;
  final double cost;
  final double price;

  Variations({
    required this.name,
    required this.quantity,
    required this.weight,
    required this.expiration,
    required this.cost,
    required this.price,
  });

  factory Variations.fromJson(Map<String, dynamic> json) {
    return Variations(
      name: json['name'],
      quantity: json['quantity'],
      weight: json['weight'],
      expiration: json['expiration'].toDate(),
      cost: json['cost'].toDouble(),
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'weight': weight,
      'expiration': expiration.toIso8601String(),
      'cost': cost.toDouble(),
      'price': price.toDouble(),
    };
  }
}
