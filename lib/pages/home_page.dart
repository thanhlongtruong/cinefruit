import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/detail_movie_screen.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/pages/movie_page.dart';
import 'package:ceni_fruit/provider/movie.dart';
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
    final style_ = TextStyle(
      color: colorTextApp,
      fontSize: textfontSizeApp,
      fontWeight: fontWeightMedium,
      letterSpacing: letterSpacingSmall,
    );
    return Column(
      spacing: spacingSmall,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${movieSelect?.name}", style: style_),
        Row(
          spacing: spacingMedium,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.star_rate_rounded, color: Colors.amber),
            Text("${movieSelect?.rate}/10", style: style_),
            Container(
              height: 15,
              decoration: const BoxDecoration(
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
      child: Container(
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
    );
  }

  Widget buildNetworkImage(String urlImage) {
    return CachedNetworkImage(
      imageUrl: urlImage,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      memCacheWidth: 400,
      memCacheHeight: 600,
      fadeInDuration: Duration(milliseconds: 50),
      placeholder: (context, url) => Center(child: circularProgress),
      errorWidget: (context, url, error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacingMedium,
          children: [
            const Icon(Icons.broken_image, size: 60, color: colorTextApp),
            const Text(
              "Không thể truy cập ảnh",
              style: TextStyle(color: colorTextApp, fontSize: textfontSizeNote),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    var icon = currentPage == 0
        ? Icons.keyboard_arrow_down_rounded
        : Icons.keyboard_arrow_up_rounded;

    return GestureDetector(
      onTap: () {
        final nextPage = currentPage == 0 ? 1 : 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          currentPage = nextPage;
        });
      },
      child: IntrinsicWidth(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: borderRadiusButton,
          ),
          margin: const EdgeInsets.symmetric(vertical: 90, horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, size: iconfontSizeApp, color: colorTextApp),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(movieHotProvider);

    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: moviesAsync.when(
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
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    return ref.read(movieProvider.notifier).refresh();
                  },
                  child: Container(
                    color: bgColorApp,
                    child: SizedBox(
                      height: screenHeight,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: imageBackground,
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              color: bgColorApp.withOpacity(0.65),
                            ),
                          ),
                          ListWheelScrollView.useDelegate(
                            itemExtent: 400,
                            physics: const FixedExtentScrollPhysics(),
                            diameterRatio: 1.6,
                            offAxisFraction: -1,
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                final movie = movies[index];
                                return buildCard(movie);
                              },
                              childCount: movies.length,
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

                                  padding: const EdgeInsets.all(14),
                                  width: MediaQuery.of(context).size.width - 60,
                                  child: Column(
                                    spacing: spacingMedium,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Phim nổi bật",
                                        style: TextStyle(
                                          color: colorTextApp,
                                          fontSize: textfontSizeTitleAppBar,
                                          letterSpacing: letterSpacingSmall,
                                          fontWeight: fontWeightTitleAppBar,
                                          shadows: [
                                            const Shadow(
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
      ),
    );
  }
}
