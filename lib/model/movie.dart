class Movie {
  String? idMovie;
  String? name;
  String? urlImage;
  String? description;
  String? video;
  String? releaseDate;
  dynamic rate;
  int? rateCount;
  String? price;
  int? duration;

  Movie({
    required this.idMovie,
    required this.name,
    required this.urlImage,
    required this.description,
    required this.video,
    required this.releaseDate,
    required this.rate,
    required this.rateCount,
    required this.price,
    required this.duration,
  });

  Movie.fromJson(Map<String, dynamic> json) {
    idMovie = json["_id"];
    name = json["name"];
    urlImage = json["urlImage"];
    description = json["description"];
    video = json["video"];
    releaseDate = json["releaseDate"];
    rate = json["rate"];
    rateCount = json["rate_count"];
    price = json["price"];
    duration = json["duration"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["urlImage"] = urlImage;
    data["description"] = description;
    data["video"] = video;
    data["releaseDate"] = releaseDate;
    data["rate"] = rate;
    data["rate_count"] = rateCount;
    data["price"] = price;
    data["duration"] = duration;
    return data;
  }
}
