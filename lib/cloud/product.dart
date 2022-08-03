import 'package:cloud_firestore/cloud_firestore.dart';

import 'constants.dart';

class Product {
  final String productId;
  final String productName;
  final String productPrice;
  final String productDescription;
  final String sellerName;
  final String productImage;
  final String category;

  Product(
      {required this.category,
      required this.productId,
      required this.productName,
      required this.productPrice,
      required this.productDescription,
      required this.sellerName,
      required this.productImage});
  Product.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : productId = snapshot.id,
        category = snapshot.data()[productCategoryFieldName] as String,
        productName = snapshot.data()[productNameFieldName] as String,
        productDescription =
            snapshot.data()[productDescriptionFieldName] as String,
        productPrice = snapshot.data()[productPriceFieldName] as String,
        sellerName = snapshot.data()[sellerNameFieldName] as String,
        productImage = snapshot.data()[productImageFieldName] as String;
}
