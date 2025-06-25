import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:ceni_fruit/model/movie.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieProvider =
    StateNotifierProvider<MovieNotifier, AsyncValue<List<Movie>>>((ref) {
      return MovieNotifier();
    });

final movieHotProvider =
    StateNotifierProvider<MovieHotNotifier, AsyncValue<List<Movie>>>((ref) {
      return MovieHotNotifier(ref);
    });

final backgroundAppProvider = StateProvider<String>((ref) => "");

Future<bool> isValidImageUrl(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200 &&
        response.headers['content-type']?.startsWith('image/') == true;
  } catch (e) {
    return false;
  }
}

abstract class BaseMovieNotifier
    extends StateNotifier<AsyncValue<List<Movie>>> {
  BaseMovieNotifier() : super(const AsyncValue.loading());

  Future<List<Movie>> loadMoviesFromJson(String path) async {
    try {
      state = const AsyncValue.loading();

      var data = await rootBundle.loadString(path);
      var json = jsonDecode(data);

      List<Movie> movies = (json["data"] as List)
          .map((d) => Movie.fromJson(d))
          .where((m) => m.urlImage != null && m.urlImage!.isNotEmpty)
          .toList();

      List<Movie> validMovies = [];
      for (var movie in movies) {
        if (await isValidImageUrl(movie.urlImage!)) {
          validMovies.add(movie);
        }
      }

      state = AsyncValue.data(validMovies);
      return validMovies;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

class MovieNotifier extends BaseMovieNotifier {
  MovieNotifier() {
    loadMovies();
  }

  Future<List<Movie>> loadMovies() {
    return loadMoviesFromJson("assets/data/movie.json");
  }

  Future<void> refresh() async {
    loadMovies();
  }
}

class MovieHotNotifier extends BaseMovieNotifier {
  MovieHotNotifier(this.ref) {
    loadMoviesHot();
  }

  final Ref ref;

  Future<List<Movie>> loadMoviesHot() async {
    List<Movie> moviesHot = await loadMoviesFromJson(
      "assets/data/movie_hot.json",
    );
    if (moviesHot.isNotEmpty) {
      final random = Random();
      final randomIndex = random.nextInt(moviesHot.length);
      final randomMovie = moviesHot[randomIndex];

      ref.read(backgroundAppProvider.notifier).state = randomMovie.urlImage!;
    }
    return moviesHot;
  }

  Future<void> refresh() async {
    await loadMoviesHot();
  }
}
