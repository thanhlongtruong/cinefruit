import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/pages/booked_ticket_page.dart';
import 'package:ceni_fruit/pages/home_page.dart';
import 'package:ceni_fruit/pages/cinema_page.dart';
import 'package:ceni_fruit/pages/user_page.dart';
import 'package:flutter/material.dart';

class HomeCreen extends StatefulWidget {
  final int index;
  const HomeCreen({super.key, this.index = 0});

  @override
  State<HomeCreen> createState() => _HomeCreenState();
}

class _HomeCreenState extends State<HomeCreen> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    final creens = [HomePage(), CinemaPage(), BookedTicketPage(), UserPage()];

    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded, size: 25),
        label: "Phim",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.theaters_rounded, size: 25),
        label: "Rạp",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history_rounded, size: 25),
        label: "Lịch sử",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_rounded, size: 25),
        label: "Tài khoản",
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
              showUnselectedLabels: false,
              onTap: (i) => setState(() => index = i),
              selectedLabelStyle: TextStyle(
                color: colorTextApp,
                letterSpacing: letterSpacingSmall,
                fontWeight: fontWeightNormal,
                fontSize: textfontSizeNote,
              ),
            ),
          ),
        ),
      ),
      body: creens[index],
    );
  }
}
