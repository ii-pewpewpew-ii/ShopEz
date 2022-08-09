import 'package:amazone_clone/cloud/product.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/utilities/show_delete_product.dart';
import 'package:amazone_clone/utilities/show_logout_dialoge.dart';
import 'package:amazone_clone/views/seller/updateProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/routes.dart';
import '../enums/menuaction.dart';
import '../views/extended_items_view.dart';

typedef CallBack = void Function(Product prod);

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder(
      {Key? key, required this.products, required this.onDeletePressed})
      : super(key: key);
  final Iterable<Product> products;
  final CallBack onDeletePressed;
  //final CallBack onUpdatePressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(addProductsFormRoute);
              },
              icon: const Icon(Icons.add),
            ),
            actions: [
              PopupMenuButton<MenuAction>(onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final decision = await showLogoutDialog(context);
                    if (decision) {
                      await AuthService.firebase().logout();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    }
                    break;
                }
              }, itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text("logout"),
                  )
                ];
              }),
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
                  child: Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.50,
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            final choice = await showDeleteDialog(context);
                            if (choice) {
                              onDeletePressed(product);
                            }
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.of(context).pushNamed(updateProductRoute,
                                arguments: UpdateProductArgument(product));
                          },
                          icon: Icons.change_circle,
                          backgroundColor: Colors.blue,
                        )
                      ],
                    ),
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
                          )
                        ]),
                  ),
                ));
          }),
          itemCount: products.length,
        ));
  }
}
