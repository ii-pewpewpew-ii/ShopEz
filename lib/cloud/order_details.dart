import 'package:amazone_clone/cloud/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetails {
  OrderDetails(this.userEmail, this.productId, this.count, this.orderId);
  OrderDetails.fromMap(Map<String, dynamic> order)
      : orderId = order[orderIdFieldName],
        userEmail = order[customerEmailFieldName] as String,
        productId = order[productIdFieldName] as String,
        count = order[quantityFieldName] as int;
  final String orderId;
  final String userEmail;
  final String productId;
  final int count;
}
