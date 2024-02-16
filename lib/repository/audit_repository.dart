import 'package:agritechv2/models/audit/Audit.dart';
import 'package:agritechv2/models/product/Products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuditRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String COLLECTION_NAME = 'audit';
  AuditRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<Products?> getAuditByProductID(String productID) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection(COLLECTION_NAME)
              .where('component', isEqualTo: ComponentType.INVENTORY.name)
              .where('action', isEqualTo: ActionType.UPDATE.name)
              .where('payload.id', isEqualTo: productID)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        final Map<String, dynamic>? data = documentSnapshot.data();

        if (data != null && data['payload'] is Map<String, dynamic>) {
          try {
            return Products.fromJson(data['payload'] as Map<String, dynamic>);
          } catch (e) {
            print("Error parsing JSON to Products: $e");
            return null;
          }
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting audit: $e");
      return null;
    }
  }
}
