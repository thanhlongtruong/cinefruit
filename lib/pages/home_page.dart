import 'dart:ui';
import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/button_call_again.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/model/detail_movie.dart';
import 'package:ceni_fruit/provider/movie_room_provider.dart';
import 'package:ceni_fruit/provider/user_profile_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/widget_loading_error.dart';
import 'package:ceni_fruit/config/catch_network_image.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/pages/movie_page.dart';
import 'package:ceni_fruit/provider/movie_hot_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  Widget boxShowInfoMovie() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.05,
      child: ClipRRect(
        borderRadius: borderRadiusCardSmall,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(spacingMedium),
            width: MediaQuery.of(context).size.width - 60,
            child: Column(
              spacing: spacingMedium,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Phim nổi bật", style: tilteStyleApp),
                if (movieSelect != null) showInfoMovie(),
              ],
            ),
          ),
        ),
      ),
    );
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
            Text("${movieSelect?.rate} / 5", style: style_),
            Container(
              height: 15,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(width: 2, color: colorTextApp),
                ),
              ),
            ),
            Text("${movieSelect?.duration} phút", style: style_),
          ],
        ),

        Text("Ngày khởi chiếu: ${movieSelect?.releaseDate}", style: style_),
      ],
    );
  }

  Widget buildCard(Movie movie) {
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
            color: colorButton,
            borderRadius: borderRadiusButton,
          ),
          margin: const EdgeInsets.symmetric(vertical: 90, horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, size: iconfontSizeNormal, color: colorTextApp),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfile);
    final movieHotAsync = ref.watch(movieHotProvider);

    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),

      child: movieHotAsync.when(
        loading: () => buildLoadingScreen(imageBackground),
        error: (error, stackTrace) {
          if (userProfileState.value?.role == "admin") {
            return buildErrorScreen(
              error,
              stackTrace,
              () => ref.read(movieHotProvider.notifier).refreshMovieHot(),
            );
          } else {
            return buttonCallAgain(
              AppBar(
                title: const Text("Phim nổi bật", style: tilteStyleApp),
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: colorTextApp),
                centerTitle: false,
              ),
              imageBackground,
              () => ref.read(movieHotProvider.notifier).refreshMovieHot(),
            );
          }
        },

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
                    return ref
                        .read(movieHotProvider.notifier)
                        .refreshMovieHot();
                  },
                  child: Container(
                    color: bgColorApp,
                    child: SizedBox(
                      height: screenHeight,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: cachedNetworkImageConfig(
                              imageBackground,
                              double.infinity,
                              double.infinity,
                              BoxFit.cover,
                              iconfontSizeCardBig,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              color: bgColorApp.withOpacity(0.60),
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
                          boxShowInfoMovie(),
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
