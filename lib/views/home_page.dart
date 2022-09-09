import 'package:amazone_clone/cloud/constants.dart';
import 'package:amazone_clone/constants/routes.dart';
import 'package:amazone_clone/views/category_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cloud/cloud_service_products.dart';
import '../utilities/buildhome.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final cloud = CloudServices();
    return Container(
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 160, 185, 135),
        child: ListView.builder(
          itemBuilder: ((context, index) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              height: 320,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 160, 185, 135)),
                    child: Material(
                      borderOnForeground: false,
                      color: const Color.fromARGB(255, 160, 185, 135),
                      elevation: 18,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(searchPageRoute,
                              arguments:
                                  GetCategory(categories.elementAt(index)));
                        },
                        leading: Text(
                          categories.elementAt(index),
                          style: GoogleFonts.rubik(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      //color: const Color.fromARGB(255, 160, 185, 135),
                      color: Colors.white,
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: StreamBuilder(
                        builder: buildHome,
                        stream: cloud.getProductByCategory(
                            category: categories.elementAt(index)),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
          itemCount: categories.length,
        ));
  }
}
