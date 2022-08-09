import 'package:amazone_clone/cloud/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String productId;
  final int count;

  CartItem(this.productId, this.count);

  CartItem.fromdoc(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : productId = snapshot.id,
        count = snapshot.data()[countFieldName] as int;
}
