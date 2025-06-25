import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/detail_movie_screen.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/provider/movie.dart';
import 'package:flutter/material.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoviePage extends ConsumerStatefulWidget {
  const MoviePage({super.key});
  @override
  ConsumerState<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends ConsumerState<MoviePage> {
  List<Movie> allMovies = [];
  List<Movie> moviesSearch = [];

  @override
  void initState() {
    super.initState();
  }

  var inputSearch = TextEditingController();
  final Set<int> errorIndexes = {};

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
        margin: const EdgeInsets.all(9),
        alignment: Alignment.center,
        decoration: errorImage
            ? const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: shadowColorBox,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              )
            : null,
        child: ClipRRect(
          borderRadius: borderRadiusCardSmall,
          child: CachedNetworkImage(
            imageUrl: movie.urlImage!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(child: circularProgress),
            errorWidget: (context, url, error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    errorIndexes.add(index);
                  });
                }
              });
              return Center(
                child: Icon(Icons.broken_image, size: 60, color: colorTextApp),
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSize buildSearch() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        margin: const EdgeInsets.only(top: spacingBig),
        height: 50,
        width: MediaQuery.of(context).size.width - 60,
        alignment: Alignment.center,
        child: TextField(
          style: TextStyle(
            fontSize: textfontSizeApp,
            fontWeight: fontWeightMedium,
            letterSpacing: letterSpacingSmall,
          ),
          controller: inputSearch,
          textAlign: TextAlign.justify,
          decoration: InputDecoration(
            hintText: 'Tìm phim',
            fillColor: colorTextApp,
            filled: true,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: inputSearch.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      inputSearch.clear();
                      funcSearch('');
                      setState(() {});
                    },
                  )
                : null,
            border: const OutlineInputBorder(
              borderRadius: borderRadiusCardSmall,
              borderSide: BorderSide(color: Colors.amberAccent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: borderRadiusCardSmall,
              borderSide: BorderSide(color: Colors.amberAccent),
            ),

            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),

          onChanged: funcSearch,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(movieProvider);
    final backgroundImage = ref.read(backgroundAppProvider);
    return moviesAsync.when(
      loading: () => buildLoadingScreen(),
      error: (error, stackTrace) => buildErrorScreen(error),
      data: (movies) {
        allMovies = movies;
        if (inputSearch.text.isEmpty) {
          moviesSearch = List.from(movies);
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: bgColorApp,
          body: RefreshIndicator(
            onRefresh: () async {
              return ref.read(movieProvider.notifier).refresh();
            },
            child: Stack(
              children: [
                if (backgroundImage.isNotEmpty)
                  ...backgroundApp(backgroundImage),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      title: Text(
                        "Danh sách phim",
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
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      bottom: buildSearch(),
                    ),

                    moviesSearch.isNotEmpty
                        ? SliverPadding(
                            padding: const EdgeInsets.only(top: spacingMedium),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 1,
                                    childAspectRatio: 0.69,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    buildItem(moviesSearch[index], index),
                                childCount: moviesSearch.length,
                              ),
                            ),
                          )
                        : const SliverFillRemaining(
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void funcSearch(String input) {
    final suggest = allMovies.where((movie) {
      final name = movie.name!.trim().toLowerCase();
      final input_ = input.trim().toLowerCase();
      return name.contains(input_);
    }).toList();

    setState(() => moviesSearch = suggest);
  }
}
