import 'package:agritechv2/models/Products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProductRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String COLLECTION_NAME = 'products';
  ProductRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Products>> getAllProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection(COLLECTION_NAME).get();
      List<Products> productsList = querySnapshot.docs
          .map((doc) => Products.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      print(productsList);
      return productsList;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Error firebase data: ${e.code} : ${e.message}");
      }
      return [];
    } catch (e) {
      print("Error fetching data: ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<Products> getProductById(String productId) async {
    try {
      final documentSnapshot = await _firebaseFirestore
          .collection(COLLECTION_NAME)
          .doc(productId)
          .get();

      if (documentSnapshot.exists) {
        final productData = documentSnapshot.data() as Map<String, dynamic>;
        final product = Products.fromJson(productData);
        return product;
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      print("Error fetching product: ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // Stream<Products> getProductById(String productId) {
  //   print('Getting user data from Cloud Firestore');
  //   return _firebaseFirestore
  //       .collection(COLLECTION_NAME)
  //       .doc(productId)
  //       .snapshots()
  //       .map((snap) => Products.fromJson(snap as Map<String, dynamic>));
  // }
}
