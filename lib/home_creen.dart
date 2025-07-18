import 'dart:ui';

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
  int indexSelected = 0;

  @override
  void initState() {
    super.initState();
    indexSelected = widget.index;
  }

  Widget bottomNavigationBarCustom() {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(
          top: spacingMedium,
          right: spacingMedium,
          left: spacingMedium,
          bottom: spacingBig,
        ),
        child: ClipRRect(
          borderRadius: borderRadiusCardBig,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.white.withOpacity(0.1)),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.white.withOpacity(0.1)),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.white.withOpacity(0.1)),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    itemBottomNavigationBarCustom(
                      icon: Icon(
                        Icons.home_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                      itemIndex: 0,
                    ),
                    itemBottomNavigationBarCustom(
                      icon: Icon(
                        Icons.theaters_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                      itemIndex: 1,
                    ),
                    itemBottomNavigationBarCustom(
                      icon: Icon(
                        Icons.history_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                      itemIndex: 2,
                    ),
                    itemBottomNavigationBarCustom(
                      icon: Icon(
                        Icons.person_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                      itemIndex: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemBottomNavigationBarCustom({
    required Icon icon,
    required int itemIndex,
  }) {
    final isSelected = indexSelected == itemIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          indexSelected = itemIndex;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.bounceOut,
        padding: const EdgeInsets.all(3),
        decoration: isSelected
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.8),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              )
            : null,
        width: 70,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final creens = [HomePage(), CinemaPage(), BookedTicketPage(), UserPage()];

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: bottomNavigationBarCustom(),
      body: creens[indexSelected],
    );
  }
}
