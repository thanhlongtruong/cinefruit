class MovieRoom {
  String? id;
  String? idMovie;
  String? idRoom;
  String? date;
  List<String>? time;

  MovieRoom({
    required this.id,
    required this.idMovie,
    required this.idRoom,
    required this.date,
    required this.time,
  });

  MovieRoom.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    idMovie = json["idMovie"];
    idRoom = json["idRoom"];
    date = json["date"];
    if (json["time"] is List) {
      time = (json["time"] as List).map((item) => item.toString()).toList();
    } else {
      time = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["idMovie"] = idMovie;
    data["idRoom"] = idRoom;
    data["time"] = time;
    data["date"] = date;
    return data;
  }
}
