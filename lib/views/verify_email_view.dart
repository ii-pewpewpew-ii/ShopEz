import 'package:amazone_clone/constants/routes.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 195, 197, 189),
        ),
        body: Column(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                margin: const EdgeInsets.fromLTRB(50, 100, 50, 30),
                height: 150,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5)
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                        'An Email has been sent to your mail, verify to Login'),
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  loginRoute, (route) => false);
                            },
                            child: const Text(login)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

const login = 'Login Page';
