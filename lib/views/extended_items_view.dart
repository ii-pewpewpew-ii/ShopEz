import 'package:amazone_clone/cloud/product.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/utilities/error_snackbox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amazone_clone/cloud/cloud_service_products.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({Key? key}) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
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
        backgroundColor: const Color.fromARGB(
          255,
          34,
          46,
          62,
        ),
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
                  color: Colors.white,
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
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: Text(
                        "${displayProduct.details.productPrice}",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: Text(
                        displayProduct.details.sellerName,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 10, right: 20),
                      child: Text(
                        displayProduct.details.productDescription,
                        style: GoogleFonts.poppins(fontSize: 22),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
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
                              icon: const Icon(Icons.remove)),
                          Text('$count'),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  count += 1;
                                });
                              },
                              icon: const Icon(Icons.add))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 50, left: 100, right: 20, bottom: 50),
                      child: SizedBox(
                        width: 180,
                        height: 50,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            primary: Colors.amber,
                          ),
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
                            style: GoogleFonts.poppins(color: Colors.black),
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
