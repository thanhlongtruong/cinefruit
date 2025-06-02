import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String imageBackground;

  @override
  void initState() {
    // TODO: implement initState
    imageBackground = "assets/images/phim_1.png";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      "assets/images/phim_1.png",
      "assets/images/phim_2.png",
      "assets/images/phim_3.png",
      "assets/images/phim_4.png",
      "assets/images/phim_5.png",
      "assets/images/phim_6.png",
      "assets/images/phim_7.png",
      "assets/images/phim_8.png",
    ];

    Widget buildCard(image) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.amberAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.purple,
              blurRadius: 16,
              spreadRadius: 2,
              offset: Offset(0, 8),
            ),
          ],
        ),
        height: 400,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            image,
            fit: BoxFit.contain,
            errorBuilder:
                (context, error, stackTrace) =>
                    Center(child: Icon(Icons.broken_image, size: 60)),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: (Image.asset(imageBackground, fit: BoxFit.fill)),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.75)),
          ),
          ListWheelScrollView.useDelegate(
            itemExtent: 400,
            physics: FixedExtentScrollPhysics(),
            diameterRatio: 1.6,
            offAxisFraction: -1,
            childDelegate: ListWheelChildLoopingListDelegate(
              children: images.map((img) => buildCard(img)).toList(),
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                imageBackground = images[index];
              });
            },
          ),
        ],
      ),
    );
  }
}
