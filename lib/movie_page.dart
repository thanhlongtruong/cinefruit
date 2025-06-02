import 'package:ceni_fruit/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List<Movie> movies_ = movies;
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

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
              color: Colors.blue.shade300,
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
      body: Stack(
        children: [
          Positioned(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child:
                  movies_.isNotEmpty
                      ? GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.69,
                        ),
                        children:
                            movies_
                                .map((cinema) => buildItem(cinema.urlImage))
                                .toList(),
                      )
                      : Center(
                        child: Text(
                          textAlign: TextAlign.justify,
                          "Không tìm thấy phim",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
            ),
          ),
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 60,
                alignment: Alignment.center,
                child: TextField(
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: "monospace",
                  ),
                  controller: inputSearch,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                    hintText: 'Search movie',
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.search_rounded),
                    suffixIcon:
                        inputSearch.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                inputSearch.clear();
                                funcSearch('');
                                setState(() {});
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.amberAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.amberAccent),
                    ),

                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),

                  onChanged: funcSearch,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void funcSearch(String input) {
    final suggest =
        movies.where((movie) {
          final name = movie.name.trim().toLowerCase();
          final input_ = input.trim().toLowerCase();
          return name.contains(input_);
        }).toList();

    setState(() => movies_ = suggest);
  }
}
