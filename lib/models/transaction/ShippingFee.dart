class ShippingFee {
  num totalItems;
  num shippingFee;
  ShippingFee({
    required this.totalItems,
    required this.shippingFee,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'shippingFee': shippingFee,
    };
  }

  factory ShippingFee.fromJson(Map<String, dynamic> json) {
    return ShippingFee(
      totalItems: json['totalItems'],
      shippingFee: json['shippingFee'],
    );
  }
}
