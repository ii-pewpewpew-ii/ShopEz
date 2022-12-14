import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class Product {
  final String productId;
  final String productName;
  final int productPrice;
  final String productDescription;
  final String sellerName;
  final String productImage;
  final String category;
  final String sellerId;
  Product(
      {required this.productId,
      required this.category,
      required this.productName,
      required this.productPrice,
      required this.productDescription,
      required this.sellerName,
      required this.productImage,
      required this.sellerId});
  Product.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : productId = snapshot.id,
        sellerId = snapshot.data()[sellerIdFieldName] as String,
        category = snapshot.data()[productCategoryFieldName] as String,
        productName = snapshot.data()[productNameFieldName] as String,
        productDescription =
            snapshot.data()[productDescriptionFieldName] as String,
        productPrice = snapshot.data()[productPriceFieldName] as int,
        sellerName = snapshot.data()[sellerNameFieldName] as String,
        productImage = snapshot.data()[productImageFieldName] as String;
 
}
