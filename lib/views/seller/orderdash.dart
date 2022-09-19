import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:amazone_clone/cloud/constants.dart';
import 'package:amazone_clone/cloud/order_Details.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/utilities/show_ship_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../cloud/product.dart';

typedef CallBack = void Function(String orderId);

class OrderDash extends StatelessWidget {
  OrderDash({Key? key, required this.onFullFillPressed}) : super(key: key);
  final _cloudServices = CloudServices();
  final uId = AuthService.firebase().currentUser!.id;
  final CallBack onFullFillPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 195, 197, 189),
          title: Center(
            child: Image.asset(
              'assets/logo.png',
              width: 100,
            ),
          )),
      body: StreamBuilder(
        builder: buildorderdash,
        stream: _cloudServices.getOrders(uId: uId),
      ),
    );
  }

  Widget buildorderdash(context, snapshot) {
    final formatCurrency = NumberFormat.compactSimpleCurrency(
      name: "INR",
      decimalDigits: 0, // change it to get decimal places
    );
    switch (snapshot.connectionState) {
      case ConnectionState.active:
        if (snapshot.hasData) {
          final data = snapshot.data;
          var products = data[ordersFieldName] as List<dynamic>;
          final orders = products.map((e) => OrderDetails.fromMap(e));
          final productIds = orders.map((order) => order.productId).toList();
          return ListView.builder(
              itemCount: orders.length,
              itemBuilder: ((context, index) {
                return FutureBuilder(
                  future: _cloudServices.getProductById(
                      productId: productIds[index]),
                  builder: ((context, snapshot) {
                    final order = orders.elementAt(index);
                    if (snapshot.connectionState == ConnectionState.done) {
                      final product = snapshot.data as Product;
                      return Stack(children: [
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
                            height: 150,
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
                                            await showShipDialog(context);
                                        if (choice) {
                                          onFullFillPressed(order.orderId);
                                        }
                                      },
                                      icon: Icons.done,
                                      backgroundColor: Colors.green,
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
                                              child: Text(product.productName,
                                                  style: GoogleFonts.rubik(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  formatCurrency.format(
                                                      product.productPrice *
                                                          order.count),
                                                  style: GoogleFonts.rubik(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                "from ${order.userEmail}",
                                                style: GoogleFonts.rubik(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                  "Quantity : ${order.count}",
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
                          ),
                        ),
                      ]);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
                );
              }));
        } else {
          return Container();
        }
      default:
        return Container();
    }
  }
}
