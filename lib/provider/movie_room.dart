import 'dart:convert';

import 'package:ceni_fruit/model/movie_room.dart';
import 'package:flutter/services.dart';

class ReadDataJsonMovieRoom {
  Future<List<MovieRoom>> loadMovieRoom() async {
    var data = await rootBundle.loadString("assets/data/movie_room.json");
    var json = jsonDecode(data);
    return (json["data"] as List).map((d) => MovieRoom.fromJson(d)).toList();
  }
}
