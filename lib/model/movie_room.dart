import 'package:ceni_fruit/model/movie.dart';
import 'package:ceni_fruit/model/room.dart';

class MovieRoom {
  String? idMovieRoom;
  dynamic idMovie;
  dynamic idRoom;
  String? date;
  List<String>? times;

  MovieRoom({
    required this.idMovieRoom,
    required this.idMovie,
    required this.idRoom,
    required this.date,
    required this.times,
  });

  MovieRoom.fromJson(Map<String, dynamic> json) {
    idMovieRoom = json["_id"];
    if (json["idMovie"] is String) {
      idMovie = json["idMovie"];
    } else if (json["idMovie"] is Map) {
      idMovie = Movie.fromJson(json["idMovie"]);
    }
    if (json["idRoom"] is String) {
      idRoom = json["idRoom"];
    } else if (json["idRoom"] is Map) {
      idRoom = Room.fromJson(json["idRoom"]);
    }
    date = json["date"];
    if (json["times"] is List) {
      times = (json["times"] as List).map((item) => item.toString()).toList();
    } else {
      times = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["idMovie"] = idMovie;
    data["idRoom"] = idRoom;
    data["time"] = times;
    data["date"] = date;
    return data;
  }
}
