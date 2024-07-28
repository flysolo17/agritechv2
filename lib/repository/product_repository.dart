import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product/Products.dart';

class ProductRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String COLLECTION_NAME = 'products';
  List<Products> PRODUCTS = [];
  ProductRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

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

  Stream<Products> getProductStreamById(String productId) {
    return _firebaseFirestore
        .collection(COLLECTION_NAME)
        .doc(productId)
        .snapshots()
        .asyncMap((documentSnapshot) async {
      if (documentSnapshot.exists) {
        final productData = documentSnapshot.data() as Map<String, dynamic>;
        final product = Products.fromJson(productData);
        return product;
      } else {
        throw Exception("Product not found");
      }
    }).handleError((error) {
      print("Error fetching product: ${error.toString()}");
      throw Exception(error.toString());
    });
  }

  Stream<List<Products>> getAllProducts() {
    final controller = StreamController<List<Products>>();

    Future.delayed(const Duration(seconds: 1), () {
      _firebaseFirestore
          .collection(COLLECTION_NAME)
          .where('expiryDate', isGreaterThan: DateTime.now())
          .where('isHidden', isEqualTo: false)
          .orderBy('expiryDate')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        final productsList =
            snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return Products.fromJson(doc.data() ?? {});
        }).toList();
        PRODUCTS = productsList;
        controller.add(productsList);
      });
    });
    return controller.stream;
  }

  Stream<List<Products>> getFeaturedProducts() {
    final controller = StreamController<List<Products>>();
    Future.delayed(const Duration(seconds: 1), () {
      _firebaseFirestore
          .collection(COLLECTION_NAME)
          .where('featured', isEqualTo: true)
          .where('expiryDate', isGreaterThan: DateTime.now())
          .where('isHidden', isEqualTo: false)
          .orderBy('expiryDate')
          .orderBy('createdAt')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        final productsList =
            snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return Products.fromJson(doc.data() ?? {});
        }).toList();
        print("${productsList} Test");
        controller.add(productsList);
      });
    });
    return controller.stream;
  }

  Future<List<Products>> searchProduct(String name) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection(COLLECTION_NAME)
        .where("name", isEqualTo: name)
        .get();

    List<Products> productList = [];
    querySnapshot.docs.forEach((doc) {
      Products product = Products.fromJson(doc.data() as Map<String, dynamic>);
      productList.add(product);
    });

    return productList;
  }
}
