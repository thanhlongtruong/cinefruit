import "dart:async";
import "package:ceni_fruit/config/show_snack_bar.dart";
import "package:ceni_fruit/config/widget_loading_error.dart";
import "package:ceni_fruit/provider/movie_hot_provider.dart";
import "package:ceni_fruit/provider/movie_provider.dart";
import "package:ceni_fruit/provider/payment_method_provider.dart";
import "package:ceni_fruit/provider/user_profile_provider.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import "package:ceni_fruit/config/const.dart";
import "package:ceni_fruit/home_creen.dart";
import "package:ceni_fruit/provider/cinema_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import '../config/path_images.dart';
import '../config/styles.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      preloadProvider();
    });
  }

  Future<void> preloadProvider() async {
    try {
      Get.dialog(Center(child: circularProgress), barrierDismissible: false);

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

      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeCreen()),
            (route) => false,
          );
        }
      });
    } catch (error, stackTrace) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      buildErrorScreen(error, stackTrace);
      return;
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
    return Scaffold(
      backgroundColor: colorTextApp,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(tag: "logo", child: Image.asset(cinefruit)),
            const SizedBox(height: spacingBig),
          ],
        ),
      ),
    );
  }
}
