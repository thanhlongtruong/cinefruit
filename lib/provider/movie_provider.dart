import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/service/movie_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ceni_fruit/model/movie.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final dio = ref.read(dioProvider);
  return MovieService(dio);
});

final movieProvider =
    StateNotifierProvider<MovieProvider, AsyncValue<List<Movie>>>((ref) {
      return MovieProvider(ref, ref.read(movieServiceProvider));
    });

class MovieProvider extends StateNotifier<AsyncValue<List<Movie>>> {
  final Ref ref;
  final MovieService movieService;

  MovieProvider(this.ref, this.movieService)
    : super(const AsyncValue.loading()) {
    loadMovies();
  }

  Future<List<Movie>> loadMovies() async {
    try {
      state = const AsyncValue.loading();

      final getMovieService = await movieService.getMovies();

      if (!getMovieService["success"]) {
        throw Exception(
          getMovieService["message"] ?? "Không thể tải danh sách phim.",
        );
      }
      List<Movie> movies = (getMovieService["movie"] as List)
          .map((m) => Movie.fromJson(m))
          .toList();

      state = AsyncValue.data(movies);

      return movies;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return [];
    }
  }

  Future<void> refreshMovie() async {
    await loadMovies();
  }
}
