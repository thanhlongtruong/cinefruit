import "dart:async";
import 'package:animated_splash_screen/animated_splash_screen.dart';
import "package:ceni_fruit/config/widget_loading_error.dart";
import "package:ceni_fruit/home_creen.dart";
import "package:ceni_fruit/provider/movie_hot_provider.dart";
import "package:ceni_fruit/provider/movie_provider.dart";
import "package:ceni_fruit/provider/user_profile_provider.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';
import "package:ceni_fruit/provider/cinema_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import '../config/path_images.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<Widget> preloadProvider() async {
    try {
      final movieHotNotifier = ref.read(movieHotProvider.notifier);
      final movieNotifier = ref.read(movieProvider.notifier);
      final cinemaNotifier = ref.read(cinemaProvider.notifier);
      final userProfileState = ref.read(userProfile.notifier);
      ref.read(backgroundMovieHot);

      final futures = [
        movieHotNotifier.loadMoviesHot(),
        movieNotifier.loadMovies(),
        cinemaNotifier.loadCinemas(),
        userProfileState.loadProfile(),
      ];

      await Future.wait(futures);

      await Future.delayed(const Duration(seconds: 1));

      return const HomeCreen();
    } catch (error, stackTrace) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      return buildErrorScreen(error, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return AnimatedSplashScreen.withScreenFunction(
      screenFunction: preloadProvider,
      splash: Image.asset(
        "assets/images/cinefruit_scare.png",
        fit: BoxFit.contain,
      ),
      backgroundColor: Colors.black,
      pageTransitionType: PageTransitionType.fade,
      splashTransition: SplashTransition.sizeTransition,
      splashIconSize: 400,
      centered: true,
      duration: 1000,
    );
  }
}
