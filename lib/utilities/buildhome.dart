import 'package:flutter/material.dart';

import '../cloud/product.dart';
import 'builditemcardscroller.dart';

Widget buildHome(BuildContext context, AsyncSnapshot<Object?> snapshot) {
  switch (snapshot.connectionState) {
    case ConnectionState.active:
      if (snapshot.hasData) {
        final products = snapshot.data as Iterable<Product>;
        return SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white
                //color: Color.fromARGB(255, 160, 185, 135),
                ),
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(5),
            height: 242,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                final product = products.elementAt(index);
                return itemBuilder(product, context);
              }),
              itemCount: products.length,
            ),
          ),
        );
      } else {
        return const Text("No items in this category");
      }
    default:
      return const CircularProgressIndicator();
  }
}
