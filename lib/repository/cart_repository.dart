import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product/Cart.dart';

class CartRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String COLLECTION_NAME = 'cart';
  CartRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> addToCart(Cart cartItem) async {
    final existingItem = await getCartItem(
        cartItem.userID, cartItem.productID, cartItem.variationID);

    if (existingItem != null) {
      final updatedQuantity = existingItem.quantity + cartItem.quantity;

      await _firebaseFirestore
          .collection(COLLECTION_NAME)
          .doc(existingItem.id)
          .update({
        'quantity': updatedQuantity,
      });
    } else {
      cartItem.id = _firebaseFirestore.collection(COLLECTION_NAME).doc().id;
      await _firebaseFirestore
          .collection(COLLECTION_NAME)
          .doc(cartItem.id)
          .set(cartItem.toJson());
    }
  }

  Stream<List<Cart>> getCartByUID(String uid) {
    final controller = StreamController<List<Cart>>();
    Future.delayed(const Duration(seconds: 1), () {
      _firebaseFirestore
          .collection(COLLECTION_NAME)
          .where('userID', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        final cartList =
            snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return Cart.fromJson(doc.data() ?? {});
        }).toList();
        controller.add(cartList);
      });
    });
    return controller.stream;
  }

  Future<Cart?> getCartItem(
      String userID, String productID, String? variationID) async {
    final querySnapshot = await _firebaseFirestore
        .collection(COLLECTION_NAME)
        .where("userID", isEqualTo: userID)
        .where('productID', isEqualTo: productID)
        .where('variationID', isEqualTo: variationID)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return Cart.fromJson(doc.data());
    } else {
      return null;
    }
  }

  Stream<Cart> getCartByID(String cartID) async* {
    print('Getting user data from Cloud Firestore');

    try {
      final snapshot = await _firebaseFirestore
          .collection(COLLECTION_NAME)
          .doc(cartID)
          .get();
      await Future.delayed(const Duration(seconds: 2));
      if (snapshot.exists) {
        yield Cart.fromJson(snapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCartQuantity(String cartID, int quantity) {
    return _firebaseFirestore
        .collection(COLLECTION_NAME)
        .doc(cartID)
        .update({"quantity": quantity});
  }
}
