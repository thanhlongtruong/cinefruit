import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/holding_seat.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/room.dart';

class Booking {
  final Movie movie;
  final MovieRoom movieRoom;
  final Cinema cinema;
  final Room room;
  final HoldingSeat? seatUser;
  final List<String> seatsDiff;
  final List<String> booked;

  Booking({
    required this.movie,
    required this.movieRoom,
    required this.cinema,
    required this.room,
    required this.seatUser,
    required this.seatsDiff,
    required this.booked,
  });
}
