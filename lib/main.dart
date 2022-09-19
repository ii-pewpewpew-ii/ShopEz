import 'package:amazone_clone/constants/routes.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/views/category_search.dart';
import 'package:amazone_clone/views/confirm_order.dart';
import 'package:amazone_clone/views/extended_items_view.dart';
import 'package:amazone_clone/views/home_page.dart';
import 'package:amazone_clone/views/home_view.dart';
import 'package:amazone_clone/views/login_view.dart';
import 'package:amazone_clone/views/seller/add_products_view.dart';
import 'package:amazone_clone/views/seller/seller_home.dart';
import 'package:amazone_clone/views/seller/update_product.dart';
import 'package:amazone_clone/views/signup_view.dart';
import 'package:amazone_clone/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51LjkvuSCMAwgDN6SbTS47lKz6HZrFfBRXtIY2fM3TO6ocZVabehFrdPCUnZtHoCGezgOfWEvceXQWDK89vQ5GNpy00uloXh7tE";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        loginRoute: (context) => const LoginView(),
        signupRoute: (context) => const SignupView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        addProductsFormRoute: (context) => const AddProductsFormView(),
        sellerHomeRoute: (context) => const SellerHomeView(),
        customerHomeRoute: ((context) => const HomePage()),
        updateProductRoute: ((context) => const UpdateProductsFormView()),
        itemDetailsRoute: ((context) => const ItemDetails()),
        mainPageRoute: ((context) => const MainPage()),
        searchPageRoute: ((context) => const CategorySearchView()),
        paymentPageRoute: ((context) => const ConfirmOrder())
      },
      home: Scaffold(
        body: FutureBuilder(
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
                  //return const ConfirmOrder();
                  return const LoginView();
                }
              default:
                {
                  return const CircularProgressIndicator();
                }
            }
          }),
          future: AuthService.firebase().initialize(),
        ),
      ),
    );
  }
}
