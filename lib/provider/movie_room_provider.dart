import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/room.dart';
import 'package:ceni_fruit/service/movie_room_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRoomService = Provider<MovieRoomService>((ref) {
  final dio = ref.read(dioProvider);
  return MovieRoomService(dio);
});

class GetMovieParams {
  final String idMovie;
  final String date;

  GetMovieParams({required this.idMovie, required this.date});
}

final movieRoomProvider =
    StateNotifierProvider.family<
      MovieRoomNotifer,
      AsyncValue<MovieRoomGetMovie>,
      GetMovieParams
    >((ref, params) {
      return MovieRoomNotifer(ref, params.idMovie, params.date);
    });

class MovieRoomGetMovie {
  final List<MovieRoom> movieRooms;
  final Movie movie;
  final List<Cinema> cinemas;
  final List<Room> rooms;

  MovieRoomGetMovie({
    required this.movieRooms,
    required this.movie,
    required this.cinemas,
    required this.rooms,
  });
}

class MovieRoomNotifer extends StateNotifier<AsyncValue<MovieRoomGetMovie>> {
  final Ref ref;
  final String idMovie;
  final String date;

  MovieRoomNotifer(this.ref, this.idMovie, this.date)
    : super(const AsyncValue.loading()) {
    loadMovieRoomIdMovie();
  }

  Future<void> loadMovieRoomIdMovie() async {
    try {
      state = AsyncValue.loading();
      final result = await ref
          .read(movieRoomService)
          .getMovieRoom(idMovie, date);
      if (result["success"]) {
        final data = result["data"];
        final movieRooms = (data["movie_room"] as List)
            .map((mr) => MovieRoom.fromJson(mr))
            .toList();

        final movie = Movie.fromJson(data["movie"]);

        final cinemas = (data["group_cinema_room"] as List)
            .map((mr) => Cinema.fromJson(mr["cinema"]))
            .toList();

        final rooms = (data["group_cinema_room"] as List)
            .expand(
              (cinemaGroup) => (cinemaGroup["rooms"] as List).map(
                (roomData) => Room.fromJson(roomData),
              ),
            )
            .toList();

        state = AsyncValue.data(
          MovieRoomGetMovie(
            movieRooms: movieRooms,
            movie: movie,
            cinemas: cinemas,
            rooms: rooms,
          ),
        );
      } else {
        state = AsyncValue.error(result["message"], StackTrace.current);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadMovieRoomIdMovie();
  }
}
