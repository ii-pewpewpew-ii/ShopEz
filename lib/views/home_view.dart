// ignore_for_file: sized_box_for_whitespace

import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:amazone_clone/enums/menuaction.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../utilities/show_logout_dialoge.dart';
import 'cart_view.dart';
import 'category_search.dart';
import 'home_page.dart';
//import 'package:carousel_slider/carousel_slider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> {
  late final _cloudService = CloudServices();
  final uId = AuthService.firebase().currentUser!.id;
  bool issearch = false;
  late ScrollController vertical, horizontal;
  @override
  void initState() {
    vertical = ScrollController();
    horizontal = ScrollController();
    issearch = false;
    super.initState();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final category = TextEditingController();
    final screens = [
      const HomePage(),
      CartView(
        onDeletePressed: (prod) async {
          await _cloudService.removeProductFromCart(
            productId: prod.productId,
            uId: uId,
          );
        },
      )
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: !issearch
            ? const Color.fromARGB(
                255,
                195,
                197,
                189,
              )
            : Colors.white,
        leading: !issearch
            ? PopupMenuButton<MenuAction>(onSelected: (value) async {
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
              })
            : IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(searchPageRoute,
                      arguments: GetCategory(category.text));
                },
                icon: const Icon(Icons.search),
                color: Colors.black,
              ),
        title: !issearch
            ? Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 100,
                ),
              )
            : TextField(
                controller: category,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Search Categories',
                ),
              ),
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
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: ((index) => setState(() => currentIndex = index)),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart')
        ],
      ),
    );
  }
}
