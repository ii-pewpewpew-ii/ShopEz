import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:amazone_clone/cloud/product.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/utilities/vertical_listview_builder.dart';
import 'package:flutter/material.dart';

class SellerDash extends StatefulWidget {
  const SellerDash({Key? key}) : super(key: key);

  @override
  State<SellerDash> createState() => _SellerDashState();
}

class _SellerDashState extends State<SellerDash> {
  String? get uId => AuthService.firebase().currentUser!.id;
  final _cloudservice = CloudServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: _cloudservice.getProductBySellerId(sellerId: uId),
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.active):
            if (snapshot.hasData) {
              final products = snapshot.data as Iterable<Product>;
              return ListViewBuilder(
                products: products,
                onDeletePressed: (prod) async {
                  await _cloudservice.deleteProduct(
                    documentId: prod.productId,
                  );
                },
              );
            } else {
              return const Text("Looks Empty, Try adding some");
            }
          default:
            return const CircularProgressIndicator();
        }
      }),
    ));
  }
}
