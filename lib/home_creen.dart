import 'dart:ui';

import 'package:ceni_fruit/pages/booked_ticket_page.dart';
import 'package:ceni_fruit/pages/movie_page.dart';
import 'package:ceni_fruit/pages/home_page.dart';
import 'package:ceni_fruit/pages/cinema_page.dart';
import 'package:ceni_fruit/pages/user_page.dart';
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
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final creens = [HomePage(), CinemaPage(), BookedTicketPage(), UserPage()];

    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded, size: 25),
        label: "Trang chủ",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.theaters_rounded, size: 25),
        label: "Rạp",
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.ticket, size: 25),
        label: "Vé",
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.user, size: 25),
        label: "Tôi",
      ),
    ];

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.black.withOpacity(0.85),
              unselectedItemColor: Colors.grey,
              selectedItemColor: Colors.cyan,
              items: items,
              currentIndex: index,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (i) => setState(() => index = i),
            ),
          ),
        ),
      ),
      body: creens[index],
    );
  }
}
