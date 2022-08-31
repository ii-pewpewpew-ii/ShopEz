import 'package:amazone_clone/cloud/product.dart';
import 'package:amazone_clone/constants/routes.dart';
import 'package:amazone_clone/views/extended_items_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget itemBuilder(Product product, BuildContext context) {
  return SizedBox(
    width: 140,
    height: 200,
    child: Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 171, 255, 251),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.02,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 182, 232, 255),
                        blurRadius: 10,
                        spreadRadius: 2),
                  ],
                  color: Color.fromARGB(255, 182, 232, 255),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  product.productImage,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 5, 0, 5),
            child: Text(
              overflow: TextOverflow.ellipsis,
              product.productName,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 5, 0, 5),
            child: Text(
              "INR ${product.productPrice}",
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(itemDetailsRoute,
                    arguments: ItemToDisplay(product));
              },
              icon: const Icon(Icons.arrow_forward))
        ],
      ),
    ),
  );
}
