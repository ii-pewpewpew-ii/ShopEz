// ignore_for_file: use_build_context_synchronously

import 'package:amazone_clone/constants/routes.dart';
import 'package:amazone_clone/services/auth/auth_exceptions.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/views/home_view.dart';
//import 'package:amazone_clone/views/verify_email_view.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/error_snackbox.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
      body: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          margin: const EdgeInsets.fromLTRB(50, 50, 50, 30),
          height: 320,
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5)
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Sign-In",
                    style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const Flexible(
                  child: SizedBox(
                height: 20,
              )),
              Flexible(
                child: TextField(
                  enableSuggestions: false,
                  controller: _email,
                  decoration: const InputDecoration(
                    hintText: "Email ID ",
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const Flexible(
                  child: SizedBox(
                height: 20,
              )),
              Flexible(
                child: TextField(
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  controller: _password,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password_sharp),
                    hintText: "Password ",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const Flexible(
                  child: SizedBox(
                height: 20,
              )),
              Flexible(
                  child: Container(
                width: MediaQuery.of(context).size.width - 40,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 232, 215, 168),
                    Color.fromARGB(255, 243, 208, 120)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await AuthService.firebase().login(
                        email: email,
                        password: password,
                      );
                      final user = AuthService.firebase().currentUser;
                      if (user != null) {
                        if (user.isEmailVerified) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              customerHomeRoute, (route) => false);
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyEmailRoute, (route) => false);
                        }
                      }
                    } on InvalidEmailAuthException {
                      showSnackBox(
                        context: context,
                        content: 'Invalid Email Try Again',
                      );
                    } on WrongPasswordAuthException {
                      showSnackBox(
                        context: context,
                        content: 'Wrong Password Try Again',
                      );
                    } on UserNotFoundAuthException {
                      showSnackBox(
                        context: context,
                        content: 'User Not Found',
                      );
                    } on GenericAuthException {
                      showSnackBox(
                        context: context,
                        content: 'An error Occurred During Login, Try Again',
                      );
                    }
                  },
                  child: Text(
                    "Sign-In",
                    style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
              )),
            ],
          ),
        ),
        Flexible(
          child: Row(children: const [
            Flexible(
              child: Divider(
                indent: 50,
                color: Colors.grey,
              ),
            ),
            Text(
              'New to Amazon?',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Flexible(
              child: Divider(
                endIndent: 50,
                color: Colors.grey,
              ),
            )
          ]),
        ),
        Flexible(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: TextButton(
                onPressed: () {
                  //For Testing
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      sellerHomeRoute, (route) => false);

                  //Navigator.of(context)
                  //   .pushNamedAndRemoveUntil(signupRoute, (route) => false);
                },
                child: const Text(signup)),
          ),
        )
      ]),
    ));
  }
}

const signup = "Sign Up";
const policy =
    "By continuing, you agree to Amazon's Conditions of Use and Privacy Notice.";
