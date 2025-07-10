import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/room.dart';
import 'package:ceni_fruit/service/cienma_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ceni_fruit/model/cinema.dart';

final cienmaServiceProvider = Provider<CinemaService>((ref) {
  final dio = ref.read(dioProvider);
  return CinemaService(dio);
});

final cinemaProvider =
    StateNotifierProvider<CinemaNotifier, AsyncValue<List<Cinema>>>((ref) {
      return CinemaNotifier(ref.read(cienmaServiceProvider));
    });

class CinemaNotifier extends StateNotifier<AsyncValue<List<Cinema>>> {
  final CinemaService cinemaService;

  CinemaNotifier(this.cinemaService) : super(const AsyncValue.loading()) {
    loadCinemas();
  }

  Future<List<Cinema>> loadCinemas() async {
    try {
      state = const AsyncValue.loading();

      final data = await cinemaService.getCinemas();

      if (!data["success"]) {
        throw Exception(data["message"]);
      }

      List<Cinema> cinemas = (data["cinema"] as List)
          .map((c) => Cinema.fromJson(c))
          .toList();

      state = AsyncValue.data(cinemas);
      return cinemas;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return [];
    }
  }

  Future<void> refreshCinema() async {
    loadCinemas();
  }
}

class DetailCinemaParams {
  final String cinemaId;
  final String date;

  DetailCinemaParams({required this.cinemaId, required this.date});
}

final detailCinemaProvider =
    StateNotifierProvider.family<
      DetailCinemaNotifier,
      AsyncValue<List<DetailCinemaState>>,
      DetailCinemaParams
    >((ref, params) {
      return DetailCinemaNotifier(ref, params.cinemaId, params.date);
    });

class DetailCinemaState {
  final Cinema cinema;
  final List<MovieRoom> movieRooms;
  final Movie movie;
  final List<Room> rooms;

  DetailCinemaState({
    required this.cinema,
    required this.movieRooms,
    required this.movie,
    required this.rooms,
  });
}

class DetailCinemaNotifier
    extends StateNotifier<AsyncValue<List<DetailCinemaState>>> {
  final Ref ref;
  final String cinemaId;
  final String date;

  DetailCinemaNotifier(this.ref, this.cinemaId, this.date)
    : super(const AsyncValue.loading()) {
    loadDetailCinema();
  }

  Future<void> loadDetailCinema() async {
    try {
      state = const AsyncValue.loading();

      final result = await ref
          .read(cienmaServiceProvider)
          .getCinema(cinemaId, date);

      if (result["success"]) {
        final data = result["data"];

        final List<DetailCinemaState> cinema = (data["cinema"] as List)
            .map(
              (c) => DetailCinemaState(
                cinema: Cinema.fromJson(c["cinema"]),
                movieRooms: (c["movie_rooms"] as List)
                    .map((mr) => MovieRoom.fromJson(mr))
                    .toList(),
                movie: Movie.fromJson(c["movie"]),
                rooms: (c["rooms"] as List)
                    .map((r) => Room.fromJson(r))
                    .toList(),
              ),
            )
            .toList();

        state = AsyncValue.data(cinema);
      } else {
        state = AsyncValue.error(result["message"], StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await loadDetailCinema();
  }
}
