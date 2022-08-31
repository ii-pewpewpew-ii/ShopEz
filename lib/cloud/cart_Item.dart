import 'package:amazone_clone/cloud/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String productId;
  final int count;

  CartItem(this.productId, this.count);

  CartItem.fromMap(Map<String, dynamic> product)
      : productId = product[productIdFieldName],
        count = product[quantityFieldName];
}
