import 'dart:io';

import 'package:ceni_fruit/detail_movie_screen.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/provider/movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});
  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List<Movie> movies = [];
  List<Movie> moviesSearch = [];
  late Future<String> movieFuture;

  Future<String> loadMovie() async {
    // movies = await ReadData().loadMovie();
    moviesSearch = List.from(movies);

    return "";
  }

  @override
  void initState() {
    super.initState();
    movieFuture = loadMovie();
  }

  var inputSearch = TextEditingController();
  final Set<int> errorIndexes = {};
  @override
  Widget build(BuildContext context) {
    Widget buildItem(Movie movie, int index) {
      final bool errorImage =
          movie.urlImage != null &&
          movie.urlImage!.isNotEmpty &&
          !errorIndexes.contains(index);
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailMovieScreen(movie: movie)),
          );
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration:
              errorImage
                  ? BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: shadowColorBox,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  )
                  : null,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: borderRadiusCardSmall,
                child: CachedNetworkImage(
                  imageUrl: movie.urlImage!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          errorIndexes.add(index);
                        });
                      }
                    });
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 60,
                        color: colorTextApp,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                right: 6,
                bottom: 8,
                child: Icon(
                  Icons.touch_app_rounded,
                  size: iconfontSizeApp,
                  color: colorTextApp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgColorApp,
      body: FutureBuilder(
        future: movieFuture,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? (Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator())
              : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    title: Text(
                      "Danh sách phim",
                      style: TextStyle(
                        color: colorTextApp,
                        fontSize: textfontSizeTitleAppBar,
                        fontFamily: fontApp,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: Colors.purple,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 60,
                        alignment: Alignment.center,
                        child: TextField(
                          style: TextStyle(
                            fontSize: textfontSizeApp,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontApp,
                          ),
                          controller: inputSearch,
                          textAlign: TextAlign.justify,
                          decoration: InputDecoration(
                            hintText: 'Tìm phim',
                            fillColor: colorTextApp,
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
                              borderRadius: borderRadiusCardSmall,
                              borderSide: BorderSide(color: Colors.amberAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: borderRadiusCardSmall,
                              borderSide: BorderSide(color: Colors.amberAccent),
                            ),

                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                          ),

                          onChanged: funcSearch,
                        ),
                      ),
                    ),
                  ),

                  moviesSearch.isNotEmpty
                      ? SliverPadding(
                        padding: const EdgeInsets.only(top: 20),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                childAspectRatio: 0.69,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                buildItem(moviesSearch[index], index),
                            childCount: moviesSearch.length,
                          ),
                        ),
                      )
                      : SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.justify,
                            "Không tìm thấy phim",
                            style: TextStyle(
                              color: colorTextApp,
                              fontSize: textfontSizeApp,
                            ),
                          ),
                        ),
                      ),
                ],
              );
        },
      ),
    );
  }

  void funcSearch(String input) {
    final suggest =
        movies.where((movie) {
          final name = movie.name!.trim().toLowerCase();
          final input_ = input.trim().toLowerCase();
          return name.contains(input_);
        }).toList();

    setState(() => moviesSearch = suggest);
  }
}
