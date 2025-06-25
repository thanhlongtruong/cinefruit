class Order {
  String? id;
  String? idMovieRoom;
  String? idUser;
  List<String>? idFoodDrink;
  String? time;
  double? price;
  String? paymentStatus;
  String? paymentMethod;
  // discount dua vao price
  int? discountCoin;
  // ap dung thuong xu khi thanh  toan thanh cong,chi tinh cho price
  int? rewardCoin;
  String? createdAt;
  String? expiredAt;

  Order({
    required this.id,
    required this.idMovieRoom,
    required this.idUser,
    this.idFoodDrink,
    required this.time,
    required this.price,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.discountCoin,
    required this.rewardCoin,
    required this.createdAt,
    required this.expiredAt,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    idMovieRoom = json["idMovieRoom"];
    idUser = json["idUser"];
    idFoodDrink = json["idFoodDrink"];
    time = json["time"];
    price = json["price"];
    paymentStatus = json["paymentStatus"];
    paymentMethod = json["paymentMethod"];
    discountCoin = json["discountCoin"];
    rewardCoin = json["rewardCoin"];
    createdAt = json["createdAt"];
    expiredAt = json["expiredAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["idMovieRoom"] = idMovieRoom;
    data["idUser"] = idUser;
    data["idFoodDrink"] = idFoodDrink;
    data["time"] = time;
    data["price"] = price;
    data["paymentStatus"] = paymentStatus;
    data["paymentMethod"] = paymentMethod;
    data["discountCoin"] = discountCoin;
    data["rewardCoin"] = rewardCoin;
    data["createdAt"] = createdAt;
    data["expiredAt"] = expiredAt;
    return data;
  }
}
