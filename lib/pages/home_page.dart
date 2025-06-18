import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/detail_movie_screen.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/pages/movie_page.dart';
import 'package:ceni_fruit/provider/movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<List<Movie>> moviesHot;
  Movie? movieSelect;

  final PageController _pageController = PageController();

  late String imageBackground = "";
  bool showMoviePage = false;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget showInfoMovie() {
    const style_ = TextStyle(
      color: colorTextApp,
      fontSize: textfontSizeNote,
      fontFamily: "monospace",
      fontWeight: FontWeight.bold,
    );
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${movieSelect?.name}", style: style_),
        Row(
          spacing: spacing,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.star_rate_rounded, color: Colors.amber),
            Text("${movieSelect?.rate}/10", style: style_),
            Container(
              height: 15,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 2, color: colorTextApp),
                ),
              ),
            ),
            Text("${movieSelect?.duration}", style: style_),
          ],
        ),

        Text("Ngày khởi chiếu: ${movieSelect?.releaseDate}", style: style_),
      ],
    );
  }

  Widget buildCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailMovieScreen(movie: movie)),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: borderRadiusCardBig,
              color: bgColorApp,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple,
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            height: 400,
            width: 266.66,
            child: ClipRRect(
              borderRadius: borderRadiusCardBig,
              child: buildNetworkImage(movie.urlImage!),
            ),
          ),
          const Positioned(
            right: 20,
            bottom: 20,
            child: Icon(
              Icons.touch_app_sharp,
              size: iconfontSizeApp,
              color: colorTextApp,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNetworkImage(String urlImage) {
    return CachedNetworkImage(
      imageUrl: urlImage,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      placeholder:
          (context, url) => Center(
            child:
                Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator(),
          ),
      errorWidget:
          (context, url, error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                const Icon(Icons.broken_image, size: 60, color: colorTextApp),
                const Text(
                  "Không thể truy cập ảnh",
                  style: TextStyle(
                    color: colorTextApp,
                    fontSize: textfontSizeNote,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget buildFloatingActionButton() {
    var icon =
        currentPage == 0
            ? Icons.keyboard_arrow_down_rounded
            : Icons.keyboard_arrow_up_rounded;

    return GestureDetector(
      onTap: () {
        final nextPage = currentPage == 0 ? 1 : 0;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          currentPage = nextPage;
        });
      },
      child: IntrinsicWidth(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: borderRadiusButton,
          ),
          margin: EdgeInsets.symmetric(vertical: 90, horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, size: iconfontSizeApp, color: colorTextApp),
          ),
        ),
      ),
    );
  }

  Widget buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.purple),
            SizedBox(height: 16),
            Text('Đang tải...', style: TextStyle(color: colorTextApp)),
          ],
        ),
      ),
    );
  }

  Widget buildErrorScreen(Object? error) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Lỗi: $error', style: TextStyle(color: colorTextApp)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(movieProvider);

    final screenHeight = MediaQuery.of(context).size.height;

    return moviesAsync.when(
      loading: () => buildLoadingScreen(),
      error: (error, stack) => buildErrorScreen(error),
      data: (movies) {
        if (movieSelect == null && movies.isNotEmpty) {
          movieSelect = movies[0];
          imageBackground = movies[0].urlImage!;
        }

        return Scaffold(
          floatingActionButton: buildFloatingActionButton(),
          body: PageView(
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  return ref.read(movieProvider.notifier).refresh();
                },
                child: Container(
                  color: Colors.black,
                  child: SizedBox(
                    height: screenHeight,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: imageBackground,
                            fit: BoxFit.fill,
                            errorWidget:
                                (context, url, error) =>
                                    Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(color: bgColorApp.withOpacity(0.65)),
                        ),
                        ListWheelScrollView.useDelegate(
                          itemExtent: 400,
                          physics: FixedExtentScrollPhysics(),
                          diameterRatio: 1.6,
                          offAxisFraction: -1,
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children:
                                movies.map((mv) => buildCard(mv)).toList(),
                          ),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              imageBackground = movies[index].urlImage!;
                              movieSelect = movies[index];
                            });
                          },
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.08,
                          child: ClipRRect(
                            borderRadius: borderRadiusCardSmall,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                color: Colors.transparent,

                                padding: EdgeInsets.all(14),
                                width: MediaQuery.of(context).size.width - 60,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Phim nổi bật",
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
                                    if (movieSelect != null) showInfoMovie(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              MoviePage(),
            ],
          ),
        );
      },
    );
  }
}
