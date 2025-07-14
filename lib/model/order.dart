import 'package:ceni_fruit/model/movie_room.dart';

class Order {
  String? idOrder;
  dynamic idMovieRoom;
  String? idUser;
  List<Map<String, dynamic>>? foodDrinks;
  String? time;
  String? date;
  String? price;
  String? paymentStatus;
  String? paymentMethod;
  String? createdAt;
  String? expiredAt;

  Order({
    required this.idOrder,
    required this.idMovieRoom,
    required this.idUser,
    this.foodDrinks,
    required this.time,
    required this.date,
    required this.price,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.createdAt,
    required this.expiredAt,
  });

  Order.fromJson(Map<String, dynamic> json) {
    idOrder = json["_id"];

    idMovieRoom = json["idMovieRoom"];

    if (json["idMovieRoom"] is String) {
      idMovieRoom = json["idMovieRoom"];
    } else if (json["idMovieRoom"] is Map) {
      idMovieRoom = MovieRoom.fromJson(json["idMovieRoom"]);
    }

    idUser = json["idUser"];

    foodDrinks = (json["foodDrinks"] as List<dynamic>)
        .map((fd) => fd as Map<String, dynamic>)
        .toList();

    time = json["time"];

    price = json["price"];

    paymentStatus = json["paymentStatus"];

    paymentMethod = json["paymentMethod"];

    createdAt = json["createdAt"];

    expiredAt = json["expiredAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["idMovieRoom"] = idMovieRoom;
    data["idUser"] = idUser;
    data["idFoodDrinkAndCount"] = foodDrinks;
    data["time"] = time;
    data["price"] = price;
    data["paymentStatus"] = paymentStatus;
    data["paymentMethod"] = paymentMethod;
    data["createdAt"] = createdAt;
    data["expiredAt"] = expiredAt;
    return data;
  }
}
