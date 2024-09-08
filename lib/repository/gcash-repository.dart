import 'dart:async';

import 'package:agritechv2/models/payment/QrCodes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const GCASH_COLLLECTION = "gcash-codes";

class GcashRepository {
  final FirebaseFirestore _firebaseFirestore;

  GcashRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance {}

  Stream<QRCodes?> getDefaultPaymentMethod() {
    final controller = StreamController<QRCodes?>();
    final query = _firebaseFirestore
        .collection(GCASH_COLLLECTION)
        .where('isDefault', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(1);

    query.snapshots().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.docs.isEmpty) {
        controller.add(null);
        return;
      }

      final doc = snapshot.docs.first;

      final qrCode = QRCodes.fromFirestore(doc);
      controller.add(qrCode);
    });

    return controller.stream;
  }
}
