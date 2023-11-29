class ShippingInfo {
  num minimum;

  num shipping;

  ShippingInfo({
    required this.minimum,
    required this.shipping,
  });

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'minimum': minimum,
      'shipping': shipping,
    };
  }

  // Deserialize from JSON
  factory ShippingInfo.fromJson(Map<String, dynamic> json) {
    return ShippingInfo(
      minimum: json['minimum'],
      shipping: json['shipping'],
    );
  }
}
