import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../cloud/cart_item.dart';
import '../cloud/cloud_service_products.dart';
import '../cloud/constants.dart';
import '../cloud/product.dart';
import '../constants/secret_key.dart';

class ConfirmOrder extends StatefulWidget {
  const ConfirmOrder({Key? key}) : super(key: key);

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  final _cloudServices = CloudServices();
  final uId = AuthService.firebase().currentUser!.id;
  final email = AuthService.firebase().currentUser!.email;
  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 195, 197, 189),
        title: Container(
          margin: const EdgeInsets.only(left: 80),
          child: Image.asset(
            'assets/logo.png',
            width: 100,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: _cloudServices.getCartProductIds(uId: uId),
          builder: buildCartItems),
    );
  }

  num total = 0;
  Widget buildCartItems(context, snapshot) {
    final formatCurrency = NumberFormat.compactSimpleCurrency(
      name: "INR",
      decimalDigits: 3,
    );

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
                              bool status = await makePayment();
                              if (status) {
                                for (int i = 0;
                                    i < productDetails.length;
                                    i++) {
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
                              }
                            },
                            child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                'Checkout Total : ' +
                                    formatCurrency.format(total),
                                style: GoogleFonts.rubik(color: Colors.white)),
                          ),
                        );
                      } else {
                        final cartProduct = cartProducts.elementAt(index);
                        final product = productDetails[cartProduct.productId];
                        total += product.productPrice * cartProduct.count;
                        return Container(
                          color: Colors.white,
                          child: Container(
                            height: 175,
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
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              .25,
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
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
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 0, 0),
                                        child: Text(
                                            formatCurrency
                                                .format(product.productPrice),
                                            style: GoogleFonts.rubik(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
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
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 0, 0),
                                        child: Text(product.productDescription,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.rubik(
                                                fontSize: 12)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
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

  Future<bool> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(total.toString(), 'INR');

      // Payment Sheet

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'ShopEz'))
          .then((value) {});

      // display sheet

      return await displayPaymentSheet();
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      log('Payment Intent Body - > ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (e) {
      log('err Charging user : ${e.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  Future<bool> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        return showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.check_circle, color: Colors.green),
                            Text("Order Confirmed")
                          ],
                        )
                      ]),
                ));
      });
      final status = await Stripe.instance
          .retrievePaymentIntent(paymentIntent!["client_secret"])
          .then((value) {
        log(value.status.toString());
        if (value.status.toString() == 'PaymentIntentsStatus.Succeeded') {
          total = 0;
          return true;
        } else {
          return false;
        }
      });
      return status;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
