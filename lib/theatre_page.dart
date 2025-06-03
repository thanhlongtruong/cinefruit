import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TheatrePage extends StatefulWidget {
  const TheatrePage({super.key});

  @override
  State<TheatrePage> createState() => _TheatrePageState();
}

class _TheatrePageState extends State<TheatrePage> {
  List<dynamic> cinemas = [];
  @override
  void initState() {
    super.initState();
    _loadCinemas();
  }

  Future<void> _loadCinemas() async {
    final String response = await rootBundle.loadString('assets/cinemas.json');
    final data = jsonDecode(response);
    setState(() {
      cinemas = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),

        child: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rạp phim',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue[900],
                      size: 13.0,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Toàn quốc',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey.shade300, height: 1),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: cinemas.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final cinema = cinemas[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                cinema['image'],
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),

            title: Text(
              cinema['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(cinema['address']), Text(cinema['phone'])],
            ),
            trailing: Text(
              cinema['distance'],
              style: TextStyle(color: Colors.blue[900], fontSize: 13),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          );
        },
      ),
    );
  }
}
