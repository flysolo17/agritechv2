import 'package:agritechv2/models/favorites/favorites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String COLLECTION_NAME = 'favorites';
  FavoritesRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  // Create
  Future<void> addFavorite(Favorites favorite) async {
    return await _firebaseFirestore
        .collection(COLLECTION_NAME)
        .doc(favorite.id)
        .set(favorite.toJson());
  }

  // Read
  Stream<List<Favorites>> streamFavoritesByCustomerId(String customerId) {
    return _firebaseFirestore
        .collection(COLLECTION_NAME)
        .where('customerID', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Favorites.fromJson(doc.data()))
            .toList());
  }

  // Update
  Future<void> updateFavorite(Favorites favorite) async {
    return await _firebaseFirestore
        .collection(COLLECTION_NAME)
        .doc(favorite.id)
        .update(favorite.toJson());
  }

  // Delete
  Future<void> deleteFavorite(String productID, String customerID) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(COLLECTION_NAME)
          .where("productID", isEqualTo: productID)
          .where("customerID", isEqualTo: customerID)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print("Error deleting favorite: $e");
      throw e;
    }
  }
}
