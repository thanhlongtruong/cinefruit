import "dart:async";

import "package:ceni_fruit/home_creen.dart";
import "package:ceni_fruit/login_screen.dart";
import "package:flutter/material.dart";
import 'config/path_images.dart';
import 'config/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeCreen()),
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorTextApp,
      body: Center(child: Hero(tag: "logo", child: Image.asset(cinefruit))),
    );
  }
}
