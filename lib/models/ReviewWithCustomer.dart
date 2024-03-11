import 'package:agritechv2/models/product/Reviews.dart';
import 'package:agritechv2/models/users/Customer.dart';

class ReviewWithCustomer {
  Reviews reviews;
  Customer? customer;
  ReviewWithCustomer({required this.reviews, required this.customer});
}
