class Room {
  String? id;
  String? idCinema;
  int? rowQuantity;
  int? colQuantity;
  String? roomNumber;

  Room({
    required this.id,
    required this.idCinema,
    required this.rowQuantity,
    required this.colQuantity,
    required this.roomNumber,
  });

  Room.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    idCinema = json["idCinema"];
    rowQuantity = json["rowQuantity"];
    colQuantity = json["colQuantity"];
    roomNumber = json["roomNumber"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["idCinema"] = idCinema;
    data["rowQuantity"] = rowQuantity;
    data["colQuantity"] = colQuantity;
    data["roomNumber"] = roomNumber;
    return data;
  }
}
