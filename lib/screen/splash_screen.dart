import "dart:async";
import "package:ceni_fruit/config/widget_loading_error.dart";
import 'package:flutter/services.dart';

import "package:ceni_fruit/config/const.dart";
import "package:ceni_fruit/home_creen.dart";
import "package:ceni_fruit/provider/cinema.dart";
import "package:ceni_fruit/provider/movie.dart";
import "package:ceni_fruit/provider/user.dart";
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
  bool isLoading = false;
  bool hasError = true;
  dynamic _error = null;

  @override
  void initState() {
    super.initState();
    preloadProvider();
  }

  Future<void> preloadProvider() async {
    try {
      setState(() {
        isLoading = true;
        _error = null;
      });

      final movieHotNotifier = ref.read(movieHotProvider.notifier);
      final movieNotifier = ref.read(movieProvider.notifier);
      final cinemaNotifier = ref.read(cinemaProvider.notifier);
      final userNotifier = ref.read(userProvider.notifier);
      ref.read(backgroundAppProvider);

      final futures = [
        movieHotNotifier.loadMoviesHot(),
        movieNotifier.loadMovies(),
        cinemaNotifier.loadCinemsFromJson(),
        userNotifier.loadUser(),
      ];

      await Future.wait(futures);
      await Future.delayed(const Duration(seconds: 2));

      setState(() => isLoading = false);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeCreen()),
          (route) => false,
        );
      }
    } catch (error, stack) {
      logger.d("error:$error, stack: $stack");
      setState(() {
        isLoading = false;
        _error = error;
      });
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
            if (isLoading)
              circularProgress
            else if (_error != null)
              buildErrorScreen(_error),
          ],
        ),
      ),
    );
  }
}
