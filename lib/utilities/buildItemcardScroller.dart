import 'package:amazone_clone/cloud/product.dart';
import 'package:amazone_clone/constants/routes.dart';
import 'package:amazone_clone/views/extended_items_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Widget itemBuilder(Product product, BuildContext context) {
  final formatCurrency = NumberFormat.compactSimpleCurrency(
    name: "INR",
    decimalDigits: 0, // change it to get decimal places
  );
  return SizedBox(
    width: 140,
    height: 200,
    child: GestureDetector(
      child: Material(
        elevation: 18,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Colors.white,
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
                  style: GoogleFonts.rubik(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 5, 0, 5),
                child: Text(
                  formatCurrency.format(product.productPrice),
                  style: GoogleFonts.rubik(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 5, 0, 5),
                child: Text(
                  (product.sellerName),
                  style: GoogleFonts.rubik(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => Navigator.of(context)
          .pushNamed(itemDetailsRoute, arguments: ItemToDisplay(product)),
    ),
  );
}
