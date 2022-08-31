import 'package:amazone_clone/cloud/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetails {
  OrderDetails(this.userEmail, this.productId, this.count, this.orderId);
  OrderDetails.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : orderId = snapshot.id,
        userEmail = snapshot.data()[customerFieldName] as String,
        productId = snapshot.data()[productIdFieldName] as String,
        count = snapshot.data()[countFieldName] as int;
  final String orderId;
  final String userEmail;
  final String productId;
  final int count;
}
