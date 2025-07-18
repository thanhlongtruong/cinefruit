import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/room.dart';

class DetailMovie {
  final Movie movie;
  final List<Cinema> cinemas;
  final List<Room> rooms;
  final List<MovieRoom> movieRooms;

  DetailMovie({
    required this.movie,
    required this.cinemas,
    required this.rooms,
    required this.movieRooms,
  });
}
