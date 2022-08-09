import 'package:amazone_clone/cloud/constants.dart';
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
        //height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[10],
        child: ListView.builder(
          itemBuilder: ((context, index) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              height: 340,
              child: Column(
                children: [
                  ListTile(
                    leading: Text(
                      categories.elementAt(index),
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
