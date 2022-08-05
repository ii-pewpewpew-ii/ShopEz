// ignore_for_file: sized_box_for_whitespace

import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cloud/product.dart';
//import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool issearch = false;
  late ScrollController vertical, horizontal;
  @override
  void initState() {
    vertical = ScrollController();
    horizontal = ScrollController();
    issearch = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cloud = CloudServices();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: !issearch
              ? const Color.fromARGB(
                  255,
                  34,
                  46,
                  62,
                )
              : Colors.white,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.menu,
                color: !issearch ? Colors.white : Colors.black,
              )),
          title: !issearch
              ? Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 100,
                  ),
                )
              : const TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black,
                      width: 2,
                    )),
                    icon: Icon(Icons.search),
                    hintText: 'Searching For?',
                  )),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    // ignore: unnecessary_this
                    this.issearch = !this.issearch;
                  });
                },
                icon: !issearch
                    ? const Icon(
                        Icons.search,
                      )
                    : const Icon(Icons.close, color: Colors.black))
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[10],
          child: Column(
            children: [
              ListTile(
                leading: Text(
                  'Technology',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: StreamBuilder(
                    builder: buildHome,
                    stream: cloud.getProductByCategory(category: 'Technology'),
                  ),
                ),
              ),
              ListTile(
                leading: Text(
                  'grocery',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: StreamBuilder(
                  builder: buildHome,
                  stream: cloud.getProductByCategory(category: 'grocery'),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildHome(BuildContext context, AsyncSnapshot<Object?> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.active:
        if (snapshot.hasData) {
          final products = snapshot.data as Iterable<Product>;
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromARGB(255, 220, 220, 220),
              ),
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) {
                  final product = products.elementAt(index);
                  return itemBuilder(product);
                }),
                itemCount: products.length,
              ),
            ),
          );
        } else {
          return const Text("No items in this category");
        }
      default:
        return const CircularProgressIndicator();
    }
  }

  Widget itemBuilder(Product product) {
    return SizedBox(
      width: 140,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
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
                    color: Colors.white70,
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
            )
          ],
        ),
      ),
    );
  }
}
