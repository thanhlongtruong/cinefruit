import 'package:ceni_fruit/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List<Cinema> cinemas_ = cinemas;

  var inputSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    Widget buildItem(i) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.amberAccent,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            i,
            fit: BoxFit.contain,
            errorBuilder:
                (context, error, stackTrace) =>
                    Center(child: Icon(Icons.broken_image, size: 60)),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Center(
            child: Container(
              color: Colors.blue,
              height: 40,
              width: MediaQuery.of(context).size.width - 60,
              margin: EdgeInsets.only(top: 100),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search movie',
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.69,
                ),
                children:
                    cinemas_
                        .map((cinema) => buildItem(cinema.urlImage))
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
