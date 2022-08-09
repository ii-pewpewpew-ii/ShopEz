 import 'package:amazone_clone/cloud/product.dart';
import 'package:amazone_clone/constants/routes.dart';
import 'package:amazone_clone/views/extended_items_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget itemBuilder(Product product,BuildContext context) {
    return SizedBox(
      width: 140,
      height: 200,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white10,
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
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ],
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
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