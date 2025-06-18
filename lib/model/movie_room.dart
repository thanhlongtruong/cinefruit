
class MovieRoom {
  String? idMovie;
  String? idRoom;
  String? time;

  MovieRoom({required this.idMovie, required this.idRoom, required this.time});

  MovieRoom.fromJson(Map<String, dynamic> json) {
    idMovie = json["idMovie"];
    idRoom = json["idRoom"];
    time = json["time"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["idMovie"] = idMovie;
    data["idRoom"] = idRoom;
    data["time"] = time;
    return data;
  }
}
