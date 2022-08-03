// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: !issearch
            ? const Color.fromARGB(
                255,
                34,
                46,
                62,
              )
            : Colors.white,
        leading: Icon(
          Icons.menu,
          color: !issearch ? Colors.white : Colors.black,
        ),
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
        height: 150,
        child: ListView.builder(
          //controller: vertical,
          scrollDirection: Axis.horizontal,
          itemCount: 6,

          itemBuilder: (context, index) => itemBuilder(),
        ),
      ),
    );
  }

  Widget categoryBuilder() {
    return ListView(
        controller: vertical,
        scrollDirection: Axis.horizontal,
        children: [
          itemBuilder(),
          itemBuilder(),
          itemBuilder(),
          itemBuilder(),
        ]);
  }

  Widget itemBuilder() {
    return Container(
      height: 100,
      width: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.black, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 5),
      ]),
    );
  }
}
