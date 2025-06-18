import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ceni_fruit/model/movie.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieProvider =
    StateNotifierProvider<MovieNotifier, AsyncValue<List<Movie>>>((ref) {
      return MovieNotifier();
    });

class MovieNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  MovieNotifier() : super(const AsyncValue.loading()) {
    loadMovies();
  }
  Future<bool> isValidImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200 &&
          response.headers['content-type']?.startsWith('image/') == true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Movie>> loadMovies() async {
    try {
      state = const AsyncValue.loading();

      var data = await rootBundle.loadString("assets/data/movie.json");
      var json = jsonDecode(data);

      List<Movie> movies =
          (json["data"] as List)
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

  Future<void> refresh() async {
    loadMovies();
  }
}
