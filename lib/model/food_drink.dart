class FoodDrink {
  String? idFoodDrink;
  String? name;
  String? type;
  bool? state;
  String? price;
  String? urlImage;

  FoodDrink({
    required this.idFoodDrink,
    required this.name,
    required this.type,
    required this.state,
    required this.price,
    required this.urlImage,
  });

  FoodDrink.fromJson(Map<String, dynamic> json) {
    idFoodDrink = json["_id"];
    name = json["name"];
    type = json["type"];
    state = json["state"];
    price = json["price"];
    urlImage = json["urlImage"];
  }
}
