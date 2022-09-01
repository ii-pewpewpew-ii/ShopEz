import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cloud/product.dart';
import '../constants/routes.dart';
import 'extended_items_view.dart';

class CategorySearchView extends StatelessWidget {
  const CategorySearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudService = CloudServices();
    final searchCategory =
        ModalRoute.of(context)!.settings.arguments as GetCategory;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(
            255,
            34,
            46,
            62,
          ),
          title: Container(
            margin: const EdgeInsets.only(left: 75),
            child: Image.asset(
              'assets/logo.png',
              width: 100,
            ),
          )),
      body: StreamBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              if (snapshot.hasData) {
                final products = snapshot.data as Iterable<Product>;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final product = products.elementAt(index);
                    return Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      margin: const EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.2)),
                        color: Colors.white,
                        elevation: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Image.network(
                                    product.productImage,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text(product.productName,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Text("INR ${product.productPrice}",
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Text("from ${product.sellerName}",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Text(
                                      product.productDescription,
                                      style: GoogleFonts.ubuntu(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        itemDetailsRoute,
                                        arguments: ItemToDisplay(product));
                                  },
                                  icon: const Icon(Icons.arrow_forward)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: products.length,
                );
              } else {
                return const CircularProgressIndicator();
              }

            default:
              return const CircularProgressIndicator();
          }
        },
        stream: cloudService.getProductByCategory(
            category: searchCategory.category),
      ),
    );
  }
}

class GetCategory {
  final String category;

  GetCategory(this.category);
}
