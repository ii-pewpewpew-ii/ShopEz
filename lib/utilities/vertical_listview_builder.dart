import 'package:amazone_clone/cloud/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/routes.dart';

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key, required this.products}) : super(key: key);
  final Iterable<Product> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(addProductsFormRoute);
                },
                icon: const Icon(Icons.add),
              ),
            ],
            backgroundColor: const Color.fromARGB(
              255,
              34,
              46,
              62,
            ),
            title: Center(
              child: Image.asset(
                'assets/logo.png',
                width: 100,
              ),
            )),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            final product = products.elementAt(index);
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.2)),
                  color: Colors.white,
                  elevation: 20,
                  child: Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.50,
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {},
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                        ),
                        SlidableAction(
                          onPressed: (context) {},
                          icon: Icons.change_circle,
                          backgroundColor: Colors.blue,
                        )
                      ],
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * .25,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                                child: Image.network(
                                  product.productImage,
                                  fit: BoxFit.fill,
                                ),
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text(product.productName,
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  )),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Text("INR ${product.productPrice}",
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  )),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Text("from ${product.sellerName}",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  )),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Text(product.productDescription,
                                        style:
                                            GoogleFonts.ubuntu(fontSize: 12)),
                                  )),
                            ],
                          )
                        ]),
                  ),
                ));
          }),
          itemCount: products.length,
        ));
  }
}
