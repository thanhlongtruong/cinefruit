import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/button_call_again.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/model/detail_movie.dart';
import 'package:ceni_fruit/provider/movie_room_provider.dart';
import 'package:ceni_fruit/provider/user_profile_provider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/config/catch_network_image.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/provider/movie_hot_provider.dart';
import 'package:ceni_fruit/provider/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:ceni_fruit/config/styles.dart';
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
      onTap: () async {
        try {
          Get.dialog(
            Center(child: circularProgress),
            barrierDismissible: false,
          );

          final dateNow = DateTime.now().add(const Duration(days: 1));
          final dateFormat = DateFormat("dd/MM/yyyy");

          final params = GetMovieParams(
            idMovie: movie.idMovie!,
            date: dateFormat.format(dateNow).toString(),
          );

          await ref
              .read(movieRoomProvider(params).notifier)
              .loadMovieRoomIdMovie();

          final state = ref.read(movieRoomProvider(params));
          if (Get.isDialogOpen == true) {
            Get.back();
          }
          if (state.hasError) {
            showSnackbar(
              title: "Lỗi hệ thống",
              message: "${state.error}",
              type: "error",
            );
          } else {
            DetailMovie params = DetailMovie(
              movie: movie,
              cinemas: state.value!.cinemas,
              movieRooms: state.value!.movieRooms,
              rooms: state.value!.rooms,
            );

            NavigationHelper.goToDetailMovie(detailMovie: params);
          }
        } catch (error) {
          if (Get.isDialogOpen == true) {
            Get.back();
          }
          showSnackbar(title: "Lỗi hệ thống", message: "$error", type: "error");
        }
      },
      child: Container(
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
          child: cachedNetworkImageConfig(
            movie.urlImage!,
            double.infinity,
            double.infinity,
            BoxFit.cover,
            iconfontSizeCardMedium,
          ),
        ),
      ),
    );
  }

  PreferredSize buildSearch() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        margin: const EdgeInsets.only(top: spacingMedium),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: spacingMedium),
        alignment: Alignment.center,
        child: TextField(
          style: const TextStyle(
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
    final userProfileState = ref.watch(userProfile);
    final backgroundImage = ref.read(backgroundMovieHot);
    final moviesAsync = ref.watch(movieProvider);
    return moviesAsync.when(
      loading: () => buildLoadingScreen(backgroundImage),
      error: (error, stackTrace) {
        if (userProfileState.value?.role == "admin") {
          return buildErrorScreen(
            error,
            stackTrace,
            () => ref.read(movieProvider.notifier).refreshMovie(),
          );
        } else {
          return buttonCallAgain(
            AppBar(
              title: const Text("Danh sách phim", style: tilteStyleApp),
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: colorTextApp),
              centerTitle: false,
            ),
            backgroundImage,
            () => ref.read(movieProvider.notifier).refreshMovie(),
          );
        }
      },

      data: (movies) {
        allMovies = movies;
        if (inputSearch.text.isEmpty) {
          moviesSearch = List.from(movies);
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: RefreshIndicator(
            onRefresh: () async {
              return ref.read(movieProvider.notifier).refreshMovie();
            },
            child: Stack(
              children: [
                if (backgroundImage.isNotEmpty)
                  ...backgroundApp(backgroundImage),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      title: const Text("Danh sách phim", style: tilteStyleApp),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: false,
                      bottom: buildSearch(),
                    ),

                    moviesSearch.isNotEmpty
                        ? SliverPadding(
                            padding: const EdgeInsets.all(spacingMedium),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.69,
                                    crossAxisSpacing: spacingMedium,
                                    mainAxisSpacing: spacingMedium,
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
                                  letterSpacing: letterSpacingSmall,
                                  fontWeight: fontWeightMedium,
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
