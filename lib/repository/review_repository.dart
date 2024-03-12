import 'package:agritechv2/models/ReviewWithCustomer.dart';
import 'package:agritechv2/models/product/Reviews.dart';
import 'package:agritechv2/models/users/Customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ReviewRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String REVIEW_COLLECTION = 'reviews';

  ReviewRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> createReview(Reviews reviews) {
    return _firebaseFirestore
        .collection(REVIEW_COLLECTION)
        .doc(reviews.id)
        .set(reviews.toJson());
  }

  Future<void> deleteReviews(String reviewID) {
    return _firebaseFirestore
        .collection(REVIEW_COLLECTION)
        .doc(reviewID)
        .delete();
  }

  Stream<List<Reviews>> getAllReviewByTransaction(String transactionID) {
    return _firebaseFirestore
        .collection(REVIEW_COLLECTION)
        .where('transactionID', isEqualTo: transactionID)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Reviews.fromJson(doc.id, doc.data()))
            .toList());
  }

  Stream<List<Reviews>> getAllReviewByProduct(String productID) {
    return _firebaseFirestore
        .collection(REVIEW_COLLECTION)
        .where('productID', isEqualTo: productID)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Reviews.fromJson(doc.id, doc.data()))
            .toList());
  }

  Stream<List<Reviews>> getAllReviewByProductID(String productID) {
    return _firebaseFirestore
        .collection(REVIEW_COLLECTION)
        .where('productID', isEqualTo: productID)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Reviews.fromJson(doc.id, doc.data()))
            .toList());
  }

  Stream<Customer?> getCustomer(String customerID) {
    print('Getting user data from Cloud Firestore');
    return _firebaseFirestore
        .collection("customers")
        .doc(customerID)
        .snapshots()
        .map((snap) => snap.exists ? Customer.fromJson(snap) : null);
  }

  Stream<List<ReviewWithCustomer>> combineStreams(String productID) {
    return getAllReviewByProductID(productID)
        .switchMap((List<Reviews> reviews) {
      Set<String> customerIDs =
          reviews.map((review) => review.customerID).toSet();

      List<Stream<ReviewWithCustomer>> customerStreams = [];
      for (String customerID in customerIDs) {
        Stream<ReviewWithCustomer> customerStream =
            getCustomer(customerID).map((Customer? customer) {
          return reviews
              .where((review) => review.customerID == customerID)
              .map((review) =>
                  ReviewWithCustomer(reviews: review, customer: customer))
              .toList();
        }).expand((element) => element);
        customerStreams.add(customerStream);
      }

      // Combine all customer streams into a single stream
      return CombineLatestStream.list(customerStreams);
    });
  }
}
