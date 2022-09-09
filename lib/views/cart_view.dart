import 'package:amazone_clone/cloud/constants.dart';
import 'package:amazone_clone/constants/routes.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/views/extended_items_view.dart';
import 'package:flutter/material.dart';
import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../cloud/cart_item.dart';
import '../cloud/product.dart';
import '../utilities/show_delete_product.dart';

typedef CallBack = void Function(Product prod);

class CartView extends StatelessWidget {
  CartView({
    Key? key,
    required this.onDeletePressed,
  }) : super(key: key);
  final CallBack onDeletePressed;

  final _cloudServices = CloudServices();
  final uId = AuthService.firebase().currentUser!.id;
  final email = AuthService.firebase().currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _cloudServices.getCartProductIds(uId: uId),
        builder: buildCartItems);
  }

  Widget buildCartItems(context, snapshot) {
    final formatCurrency = NumberFormat.compactSimpleCurrency(
      name: "INR",
      decimalDigits: 3,
    );
    num total = 0;
    switch (snapshot.connectionState) {
      case ConnectionState.active:
        if (snapshot.hasData) {
          final data = snapshot.data;
          final products = data[productsFieldName] as List<dynamic>;
          final cartProducts =
              products.map((e) => CartItem.fromMap(e)).toList();
          final productIds =
              cartProducts.map((cartItem) => cartItem.productId).toList();
          productIds.sort();
          return StreamBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  var data = snapshot.data as List<Product>;
                  var productDetails = {};
                  for (dynamic product in data) {
                    productDetails[product.productId] = product;
                  }
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      if (index == productDetails.length) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                          width: MediaQuery.of(context).size.width - 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 189, 208, 190),
                                  Color.fromARGB(255, 198, 228, 167)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              for (int i = 0; i < productDetails.length; i++) {
                                CartItem cartProduct =
                                    cartProducts.elementAt(i);
                                Product product =
                                    productDetails[cartProduct.productId];
                                await _cloudServices.addOrderToSellerDash(
                                    email: email,
                                    sellerId: product.sellerId,
                                    productId: product.productId,
                                    count: cartProduct.count);
                              }
                              await _cloudServices.checkout(uId: uId);
                            },
                            child: Text(
                                'Checkout Total : ' +
                                    formatCurrency.format(total),
                                style: GoogleFonts.rubik(color: Colors.white)),
                          ),
                        );
                      } else {
                        final cartProduct = cartProducts.elementAt(index);
                        final product = productDetails[cartProduct.productId];
                        total += product.productPrice * cartProduct.count;
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              itemDetailsRoute,
                              arguments: ItemToDisplay(product)),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.2),
                            ),
                            color: Colors.white,
                            elevation: 25,
                            child: Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.4,
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      final choice =
                                          await showDeleteDialog(context);
                                      if (choice) {
                                        onDeletePressed(product);
                                      }
                                    },
                                    icon: Icons.delete,
                                    backgroundColor: Colors.red,
                                  ),
                                ],
                              ),
                              child: Container(
                                height: 150,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(top: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .25,
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          child: Image.network(
                                            product.productImage,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 0, 0),
                                            child: Text(product.productName,
                                                style: GoogleFonts.rubik(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 0, 0),
                                            child: Text(
                                                formatCurrency.format(
                                                    product.productPrice),
                                                style: GoogleFonts.rubik(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 0, 0),
                                            child: Text(
                                              "from ${product.sellerName}",
                                              style: GoogleFonts.rubik(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 0, 0),
                                            child: Text(
                                                product.productDescription,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.rubik(
                                                    fontSize: 12)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 0, 0),
                                            child: Text(
                                                "Quantity : ${cartProduct.count}",
                                                style: GoogleFonts.rubik(
                                                    fontSize: 12)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                    itemCount: productDetails.length + 1,
                  );
                default:
                  return const CircularProgressIndicator();
              }
            },
            stream: _cloudServices.getCartItems(productIds: productIds),
          );
        } else {
          return const CircularProgressIndicator();
        }
      default:
        return const CircularProgressIndicator();
    }
  }
}
