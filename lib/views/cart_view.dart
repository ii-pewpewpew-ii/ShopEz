import 'package:amazone_clone/cloud/constants.dart';
import 'package:amazone_clone/constants/routes.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/views/extended_items_view.dart';
import 'package:flutter/material.dart';
import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Scaffold(
      body: StreamBuilder(
          stream: _cloudServices.getCartProductIds(uId: uId),
          builder: buildCartItems),
    );
  }

  /*
  ->Each user has a seperate collection to store his/her cart products
  ->To retreive from the 2 collections 'product' and 'user_cart' 
  ->we use Nested Stream Builders
  */
  Widget buildCartItems(context, snapshot) {
    int total = 0;
    switch (snapshot.connectionState) {
      case ConnectionState.active:
        if (snapshot.hasData) {
          final data = snapshot.data;
          final products = data[productsFieldName] as List<dynamic>;
          final cartProducts = products.map((e) => CartItem.fromMap(e));
          final productIds = cartProducts.map((cartItem) => cartItem.productId);
          return StreamBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  final products = snapshot.data as Iterable<Product>;
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: ((context, index) {
                              if (index == products.length) {
                                return Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                  width: MediaQuery.of(context).size.width - 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 255, 219, 121),
                                          Color.fromARGB(255, 255, 203, 32)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      for (int i = 0;
                                          i < products.length;
                                          i++) {
                                        CartItem cartProduct =
                                            cartProducts.elementAt(i);
                                        Product product = products.elementAt(i);
                                        await _cloudServices
                                            .addOrderToSellerDash(
                                                email: email,
                                                sellerId: product.sellerId,
                                                productId: product.productId,
                                                count: cartProduct.count);
                                        await _cloudServices
                                            .removeProductFromCart(
                                          productId: product.productId,
                                          uId: uId,
                                        );
                                      }
                                    },
                                    child: Text('Checkout Total : $total'),
                                  ),
                                );
                              } else {
                                final product = products.elementAt(index);
                                final cartProduct =
                                    cartProducts.elementAt(index);
                                total +=
                                    product.productPrice * cartProduct.count;
                                return Card(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        .25,
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 0, 0),
                                                  child: Text(
                                                      product.productName,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 0, 0),
                                                  child: Text(
                                                      "INR ${product.productPrice}",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 0, 0),
                                                  child: Text(
                                                    "from ${product.sellerName}",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 0, 0),
                                                  child: Text(
                                                      product
                                                          .productDescription,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.ubuntu(
                                                          fontSize: 12)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 0, 0),
                                                  child: Text(
                                                      "Quantity : ${cartProduct.count}",
                                                      style: GoogleFonts.ubuntu(
                                                          fontSize: 12)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          itemDetailsRoute,
                                                          arguments:
                                                              ItemToDisplay(
                                                                  product));
                                                },
                                                icon: const Icon(
                                                    Icons.arrow_forward)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }),
                            itemCount: products.length + 1,
                          ),
                        ),
                      ),
                    ],
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
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        return const CircularProgressIndicator();
    }
  }
}
