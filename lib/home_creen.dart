import 'package:ceni_fruit/movie_page.dart';
import 'package:ceni_fruit/home_page.dart';
import 'package:ceni_fruit/theatre_page.dart';
import 'package:ceni_fruit/user_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttericon/maki_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class HomeCreen extends StatefulWidget {
  const HomeCreen({super.key});

  @override
  State<HomeCreen> createState() => _HomeCreenState();
}

class _HomeCreenState extends State<HomeCreen> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    final creens = [MoviePage(), HomePage(), TheatrePage(), UserPage()];

    final items = <Widget>[
      Padding(
        padding: EdgeInsets.all(6), // chỉnh giá trị padding theo ý bạn
        child: Icon(Maki.cinema, size: 25),
      ),
      Padding(
        padding: EdgeInsets.all(6),
        child: Icon(Icons.home_rounded, size: 25),
      ),
      Padding(
        padding: EdgeInsets.all(6),
        child: Icon(Icons.theaters_rounded, size: 25),
      ),
      Padding(
        padding: EdgeInsets.all(6),
        child: FaIcon(FontAwesomeIcons.user, size: 25),
      ),
    ];

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(
          context,
        ).copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.black38,
          height: 60,
          index: index,
          items: items,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
      body: creens[index],
    );
  }
}
