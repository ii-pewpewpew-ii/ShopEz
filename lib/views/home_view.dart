import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  bool issearch = false;
  @override
  void initState() {
    issearch = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: !issearch
                ? const Color.fromARGB(
                    255,
                    34,
                    46,
                    62,
                  )
                : Colors.white,
            expandedHeight: 300,
            flexibleSpace: ListView(
              children: [
                CarouselSlider(
                  items: [
                    Container(
                      //margin: const EdgeInsets.fromLTRB(left, top, right, bottom)
                      child: Image.asset('assets/banner1.jpeg'),
                    )
                  ],
                  options: CarouselOptions(),
                )
              ],
            ),
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
                        color: Colors.white,
                        width: 1.5,
                      )),
                      icon: Icon(Icons.search),
                      hintText: 'Searching For?',
                    )),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      this.issearch = !this.issearch;
                    });
                  },
                  icon: !issearch
                      ? const Icon(
                          Icons.search,
                        )
                      : const Icon(Icons.close, color: Colors.black))
            ],
          )
        ],
      ),
    );
  }
}
