import 'package:amazone_clone/cloud/product.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/utilities/error_snackbox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:intl/intl.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({Key? key}) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final formatCurrency = NumberFormat.compactSimpleCurrency(
    name: "INR",
    decimalDigits: 3, 
  );
  int count = 1;
  @override
  Widget build(BuildContext context) {
    final userEmail = AuthService.firebase().currentUser!.id;
    final cloudService = CloudServices();
    final displayProduct =
        ModalRoute.of(context)!.settings.arguments as ItemToDisplay;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: const Color.fromARGB(255, 195, 197, 189),
        title: Container(
          margin: const EdgeInsets.only(left: 80),
          child: Image.asset(
            'assets/logo.png',
            width: 100,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(displayProduct.details.productImage),
                    fit: BoxFit.cover)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 160, 185, 135),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, -4),
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8)
                  ]),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Text(
                        displayProduct.details.productName,
                        style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: Text(
                        formatCurrency
                            .format(displayProduct.details.productPrice),
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: Text(
                        displayProduct.details.sellerName,
                        style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: Text(
                        displayProduct.details.productDescription,
                        style: GoogleFonts.rubik(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 5, right: 20),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (count > 1) {
                                    count -= 1;
                                  } else {
                                    count = 1;
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              )),
                          Text('$count',
                              style: GoogleFonts.rubik(
                                  color: Colors.white, fontSize: 16)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  count += 1;
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 100, right: 20, bottom: 50),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 189, 208, 190),
                          Color.fromARGB(255, 198, 228, 167)
                        ])),
                        width: 180,
                        height: 50,
                        child: TextButton(
                          onPressed: () async {
                            await cloudService.addProductToCart(
                              productId: displayProduct.details.productId,
                              count: count,
                              uId: userEmail,
                            );
                            showSnackBox(
                                context: context,
                                content: 'Product Added To Cart');
                          },
                          child: Text(
                            "Add To Cart",
                            style: GoogleFonts.rubik(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ItemToDisplay {
  final Product details;
  ItemToDisplay(this.details);
}
