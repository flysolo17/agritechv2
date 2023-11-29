class Variation {
  String id;
  String name;
  String image;
  num cost;
  num price;
  int stocks;

  Variation({
    required this.id,
    required this.name,
    required this.image,
    required this.cost,
    required this.price,
    required this.stocks,
  });

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'cost': cost,
      'price': price,
      'stocks': stocks,
    };
  }

  // Deserialize from JSON
  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      cost: json['cost'],
      price: json['price'],
      stocks: json['stocks'],
    );
  }
}
