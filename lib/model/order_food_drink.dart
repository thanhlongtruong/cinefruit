import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/holding_seat.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/room.dart';

class ParamsOrderFoodDrink {
  final Movie movie;
  final Cinema cinema;
  final Room room;
  final MovieRoom movieRoom;
  final List<String> selectedSeats;
  final String price;
  final String time;
  final HoldingSeat? seatUser;

    ParamsOrderFoodDrink({
    required this.movie,
    required this.cinema,
    required this.room,
    required this.movieRoom,
    required this.selectedSeats,
    required this.price,
    required this.time,
    required this.seatUser,
  });
}