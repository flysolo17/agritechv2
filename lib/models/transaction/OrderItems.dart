import 'package:agritechv2/models/product/Shipping.dart';

class OrderItems {
  String productID;
  String productName;
  bool isVariation;
  String variationID;
  int quantity;

  num cost;
  num price;
  String imageUrl;
  ShippingInfo shippingInfo;

  OrderItems(
      {required this.productID,
      required this.productName,
      required this.isVariation,
      required this.variationID,
      required this.quantity,
      required this.cost,
      required this.price,
      required this.imageUrl,
      required this.shippingInfo});
  num getProductTotal() {
    return price * quantity;
  }

  num getShippingFee() {
    if (quantity >= shippingInfo.minimum) {
      return shippingInfo.shipping;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'productName': productName,
      'isVariation': isVariation,
      'variationID': variationID,
      'quantity': quantity,
      'cost': cost,
      'price': price,
      'imageUrl': imageUrl,
      'shippingInfo': shippingInfo.toJson()
    };
  }

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
        productID: json['productID'],
        productName: json['productName'],
        isVariation: json['isVariation'],
        variationID: json['variationID'],
        quantity: json['quantity'],
        cost: json['cost'],
        price: json['price'],
        imageUrl: json['imageUrl'],
        shippingInfo: ShippingInfo.fromJson(json['shippingInfo']));
  }
}
