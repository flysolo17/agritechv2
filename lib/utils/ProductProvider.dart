import 'package:agritechv2/models/Products.dart';

class ProductProvider {
  List<Products> productList;
  ProductProvider({required List<Products> products}) : productList = products;

  Set<String> getProductCategories() {
    Set<String> filteredItemNames = {};

    for (var item in productList) {
      item.category.toLowerCase();
      filteredItemNames.add(item.category);
    }

    return filteredItemNames;
  }

  List<Products> getProductsByCategory(String category) {
    print("Filtering for category: $category");
    List<Products> filteredList = [];

    for (var item in productList) {
      if (item.category.toLowerCase() == category.toLowerCase()) {
        filteredList.add(item);
      }
    }

    print("Filtered list length: ${filteredList.length}");

    return filteredList;
  }
}
