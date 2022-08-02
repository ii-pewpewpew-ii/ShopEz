import 'package:amazone_clone/constants/routes.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/views/home_view.dart';
import 'package:amazone_clone/views/login_view.dart';
import 'package:amazone_clone/views/signup_view.dart';
import 'package:amazone_clone/views/verify_email_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        loginRoute: (context) => const loginView(),
        signupRoute: (context) => const signupView(),
        verifyEmailRoute: (context) => const verifyEmailView()
      },
      home: Scaffold(
        body: FutureBuilder(
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
                  return const homePage();
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
