import 'package:agritechv2/models/transaction/OrderItems.dart';
import 'package:agritechv2/models/transaction/TransactionSchedule.dart';
import 'package:agritechv2/models/transaction/TransactionStatus.dart';
import 'package:agritechv2/models/users/Users.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';
import 'dart:math';
import '../models/product/Cart.dart';
import '../models/product/Products.dart';
import '../models/product/Shipping.dart';
import '../models/transaction/PaymentMethod.dart';

const GCASH_LINK =
    "https://firebasestorage.googleapis.com/v0/b/agri-bot-75fb6.appspot.com/o/gcash.jpg?alt=media&token=11475363-e37d-4442-b4d6-5e2542181245";
const GCASH_APP =
    "https://play.google.com/store/apps/details?id=com.globe.gcash.android&pcampaignid=web_share";
const int STANDARD_DELIVERY = 10;
PaymentType getSelectedPaymentMethod(int selectedIndex) {
  switch (selectedIndex) {
    case 0:
      return PaymentType.COD;
    case 1:
      return PaymentType.GCASH;
    default:
      return PaymentType.PAY_IN_COUNTER;
  }
}

int countOrder(List<OrderItems> orderItems) {
  int total = 0;
  orderItems.map((prod) => {total += prod.quantity});
  return total;
}

// if orderITems total quantity > 50 return true else checkMinimum quantity
bool areAllItemsAboveMinimum(List<OrderItems> orderItems) {
  for (OrderItems item in orderItems) {
    if (item.quantity < item.shippingInfo.minimum) {
      return false;
    }
  }
  return true;
}

num computeShipping(List<OrderItems> orderItems) {
  num shipping = 0.0;
  for (var item in orderItems) {
    shipping += item.quantity * item.getShippingFee();
  }
  return shipping;
}

num computeTotalOrder(List<OrderItems> orderItems) {
  num total = 0.0;
  for (var item in orderItems) {
    total += item.getProductTotal();
  }
  return total;
}

int countOrders(List<OrderItems> orderItems) {
  int total = 0;

  for (var item in orderItems) {
    total += item.quantity;
  }
  return total;
}

List<String> productCategories(List<Products> products) {
  Set<String> uniqueCategories = <String>{};
  for (var product in products) {
    uniqueCategories.add(product.category);
  }
  return uniqueCategories.toList();
}

List<Products> filterProductsByCategory(
    List<Products> products, String category) {
  return products.where((product) => product.category == category).toList();
}

String formatPrice(num value) {
  final currencyFormat = NumberFormat.currency(decimalDigits: 2, symbol: '\₱');
  return currencyFormat.format(value);
}

String getEffectivePrice(Products products) {
  if (products.variations.isEmpty) {
    return formatPrice(products.price);
  } else {
    // Calculate the min and max price from variations
    num minPrice = double.maxFinite;
    num maxPrice = double.negativeInfinity;

    for (var variation in products.variations) {
      if (variation.price < minPrice) {
        minPrice = variation.price;
      }
      if (variation.price > maxPrice) {
        maxPrice = variation.price;
      }
    }

    if (minPrice == maxPrice) {
      return formatPrice(minPrice);
    } else {
      return '${formatPrice(minPrice)} - ${formatPrice(maxPrice)}';
    }
  }
}

Shimmer shimmerLoading1() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 20,
                width: 20,
                color: Colors.grey,
              ),
            ),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Shimmer usersShimer() {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 150,
        width: double.infinity,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    width: 100.0,
                    height: 10,
                    color: Colors.grey,
                  )
                ],
              );
            }),
      ));
}

Shimmer shimmerLoading2() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            color: Colors.grey,
            height: 16,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            color: Colors.grey,
            height: 12,
          ),
        ],
      ),
    ),
  );
}

Widget buyLoadingPage() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        Container(
          height: 60,
          margin: const EdgeInsets.all(8.0),
          child: ListView.separated(
            scrollDirection:
                Axis.horizontal, // Set the scroll direction to horizontal
            separatorBuilder: (context, index) =>
                const SizedBox(width: 10.0), // Add a 10-pixel gap
            itemCount: 3, // Number of items in the list
            itemBuilder: (context, index) {
              return Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5.0)),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
            ),
            itemBuilder: (context, index) {
              return shimmerLoading2();
            },
            itemCount: 6, // Number of items in the grid
          ),
        ),
      ],
    ),
  );
}

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}...';
  }
}

String formatDateTime(DateTime dateTime) {
  String formattedDate = "${_getMonthAbbreviation(dateTime.month)} "
      "${dateTime.day.toString().padLeft(2, '0')} "
      "${dateTime.hour.toString().padLeft(2, '0')}:"
      "${dateTime.minute.toString().padLeft(2, '0')} "
      "${_getAmPm(dateTime.hour)}";

  return formattedDate;
}

String _getMonthAbbreviation(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}

String _getAmPm(int hour) {
  return hour >= 12 ? 'PM' : 'AM';
}

Color getColor(TransactionStatus status) {
  switch (status) {
    case TransactionStatus.PENDING:
      return Colors.grey;
    case TransactionStatus.COMPLETED:
      return Colors.green;
    case TransactionStatus.CANCELLED:
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String generateInvoiceID() {
  int timestamp = DateTime.now().microsecondsSinceEpoch;

  int randomPart = Random().nextInt(100000);

  String invoiceID = '$timestamp${randomPart.toString().padLeft(5, '0')}';

  return invoiceID;
}

Users? findUserById(List<Users> userList, String userId) {
  try {
    return userList.firstWhere((user) => user.id == userId);
  } catch (e) {
    // Handle exceptions if necessary
    print('Error finding user: $e');
    return null;
  }
}

String formatTimeDifference(DateTime dateTime) {
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 365) {
    int years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  } else if (difference.inDays >= 30) {
    int months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  } else if (difference.inDays >= 7) {
    int weeks = (difference.inDays / 7).floor();
    return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'min' : 'mins'} ago';
  } else {
    return 'just now';
  }
}
