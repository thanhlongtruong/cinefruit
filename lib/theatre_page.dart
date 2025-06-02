import 'package:flutter/material.dart';

class TheatrePage extends StatefulWidget {
  const TheatrePage({super.key});

  @override
  State<TheatrePage> createState() => _TheatrePageState();
}

class _TheatrePageState extends State<TheatrePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("THEATRE PAGE")));
  }
}
