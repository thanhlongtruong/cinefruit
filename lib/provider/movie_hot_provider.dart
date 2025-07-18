import 'dart:math';

import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/service/movie_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ceni_fruit/model/movie.dart';

final movieHotServiceProvider = Provider<MovieService>((ref) {
  final dio = ref.read(dioProvider);
  return MovieService(dio);
});

final backgroundMovieHot = StateProvider<String>((ref) => "");

final movieHotProvider =
    StateNotifierProvider<MovieHotProvider, AsyncValue<List<Movie>>>((ref) {
      return MovieHotProvider(ref.read(movieHotServiceProvider), ref);
    });

class MovieHotProvider extends StateNotifier<AsyncValue<List<Movie>>> {
  final Ref ref;
  final MovieService movieHotService;

  MovieHotProvider(this.movieHotService, this.ref)
    : super(const AsyncValue.loading()) {
    loadMoviesHot();
  }

  Future<List<Movie>> loadMoviesHot() async {
    try {
      state = const AsyncValue.loading();

      final getMoviesHot = await movieHotService.getMovieHot();

      if (!getMoviesHot["success"]) {
        throw Exception(
          getMoviesHot["message"] ?? "Không thể tải danh sách phim nổi bật.",
        );
      }

      List<Movie> moviesHot = (getMoviesHot["movie"] as List)
          .map((m) => Movie.fromJson(m))
          .toList();

      if (moviesHot.isNotEmpty) {
        final random = Random();
        final randomIndex = random.nextInt(moviesHot.length);
        final movieIndex = moviesHot[randomIndex];
        ref.read(backgroundMovieHot.notifier).state = movieIndex.urlImage!;
      }

      state = AsyncValue.data(moviesHot);

      return moviesHot;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return [];
    }
  }

  Future<void> refreshMovieHot() async {
    await loadMoviesHot();
  }
}
