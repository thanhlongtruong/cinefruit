import 'package:ceni_fruit/model/cinema.dart';

class Room {
  String? idRoom;
  dynamic idCinema;
  int? rowQuantity;
  int? colQuantity;
  String? roomNumber;

  Room({
    required this.idRoom,
    required this.idCinema,
    required this.rowQuantity,
    required this.colQuantity,
    required this.roomNumber,
  });

  Room.fromJson(Map<String, dynamic> json) {
    idRoom = json["_id"];
    idCinema = json["idCinema"];
    if (json["idCinema"] is String) {
      idCinema = json["idCinema"];
    } else if (json["idCinema"] is Map) {
      idCinema = Cinema.fromJson(json["idCinema"]);
    }
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
