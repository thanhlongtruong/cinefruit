import 'package:ceni_fruit/model/movie_room.dart';

class HoldingSeat {
  String? idHoldingSeat;
  String? idUser;
  dynamic idMovieRoom;
  List<String>? selectedSeat;
  String? expiredAt;
  String? createdAt;

  HoldingSeat(
    this.idHoldingSeat,
    this.idUser,
    this.idMovieRoom,
    this.selectedSeat,
  );

  HoldingSeat.fromJson(Map<String, dynamic> json) {
    idHoldingSeat = json["_id"];
    idUser = json["idUser"];
    if (json["idMovieRoom"] is String) {
      idMovieRoom = json["idMovieRoom"];
    } else if (json["idMovieRoom"] is Map) {
      idMovieRoom = MovieRoom.fromJson(json["idMovieRoom"]);
    }
    selectedSeat = (json["selectedSeat"] as List)
        .map((s) => s.toString())
        .toList();
    createdAt = json["createdAt"];
    expiredAt = json["expiredAt"];
  }
}
