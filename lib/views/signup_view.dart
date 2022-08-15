import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:amazone_clone/constants/routes.dart';
import 'package:amazone_clone/services/auth/auth_exceptions.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:amazone_clone/services/auth/firebase_auth_provider.dart';
import 'package:amazone_clone/utilities/error_snackbox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupView extends StatefulWidget {
  const SignupView({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final authService = FirebaseAuthProvider;
  bool? isseller = false;
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
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          margin: const EdgeInsets.fromLTRB(50, 50, 50, 50),
          height: 420,
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
                    "Sign-Up",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 25,
                        color: Colors.black),
                  )
                ],
              ),
              const Flexible(
                child: SizedBox(
                  height: 30,
                ),
              ),
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
                  height: 30,
                ),
              ),
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
                height: 30,
              )),
              Flexible(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                height: 60,
                child: Row(children: [
                  Checkbox(
                      value: isseller,
                      onChanged: (value) {
                        setState(() {
                          isseller = value;
                        });
                      }),
                  const Text('Check this for creating a\nSeller Account'),
                ]),
              )),
              const Flexible(
                  child: SizedBox(
                height: 30,
              )),
              Flexible(
                  child: Container(
                width: MediaQuery.of(context).size.width - 40,

                //color: Colors.amber,
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
                      await AuthService.firebase().signup(
                        email: email,
                        password: password,
                      );

                      if (isseller != null) {
                        if (isseller!) {
                          await CloudServices().addSeller(email: _email.text);
                        }
                      }
                      await AuthService.firebase().sendEmailVerification();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute, (route) => false);
                    } on EmailAlreadyInUseAuthException {
                      showSnackBox(
                        context: context,
                        content: 'Email Already In Use',
                      );
                    } on WeakPasswordAuthException {
                      showSnackBox(
                        context: context,
                        content: 'Weak Password',
                      );
                    } on InvalidEmailAuthException {
                      showSnackBox(context: context, content: 'Invalid Email');
                    } on GenericAuthException {
                      showSnackBox(
                        context: context,
                        content: 'Signup failed ',
                      );
                    }
                  },
                  child: Text(
                    "Sign-Up",
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
            Flexible(
              child: Text(
                'Been here Already?',
                style: TextStyle(
                  color: Colors.grey,
                ),
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
        //const SizedBox(height: 10),
        Flexible(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text(login)),
          ),
        )
      ]),
    ));
  }
}

const login = "Log in";
