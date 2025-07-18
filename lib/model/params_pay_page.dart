import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/holding_seat.dart';
import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/payment_method.dart';
import 'package:ceni_fruit/model/room.dart';

class ParamsPayPage {
  final Movie movie;
  final Cinema cinema;
  final Room room;
  final String selectedTime;
  final MovieRoom movieRoom;
  final List<PaymentMethod> paymentMethods;
  final HoldingSeat? seatUser;

  final List<Map<String, dynamic>> totalChooseFoodDrink;

  final List<String> selectedSeats;
  final String price;
  final String typeInformationThisPage;
  final String selectedPaymentMethod;

  ParamsPayPage({
    required this.movie,
    required this.cinema,
    required this.room,
    required this.selectedTime,
    required this.movieRoom,
    required this.paymentMethods,
    required this.seatUser,
    required this.totalChooseFoodDrink,
    required this.selectedSeats,
    required this.price,
    this.typeInformationThisPage = "page_payment",
    this.selectedPaymentMethod = "",
  });
}
