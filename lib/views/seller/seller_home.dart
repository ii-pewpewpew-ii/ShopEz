import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/views/seller/orderdash.dart';
import 'package:amazone_clone/views/seller/seller_dash.dart';
import 'package:flutter/material.dart';

class SellerHomeView extends StatefulWidget {
  const SellerHomeView({Key? key}) : super(key: key);

  @override
  State<SellerHomeView> createState() => _SellerHomeViewState();
}

class _SellerHomeViewState extends State<SellerHomeView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final email = AuthService.firebase().currentUser!.id;
    final cloudService = CloudServices();
    final screens = [
      const SellerDash(),
      OrderDash(onFullFillPressed: (orderId) {
        cloudService.fullfillOrder(orderId: orderId, uId: email);
      })
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
            icon: Icon(Icons.dashboard),
            label: 'Orders',
          )
        ],
      ),
    );
  }
}
