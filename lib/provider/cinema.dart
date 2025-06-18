import 'dart:convert';

import 'package:ceni_fruit/model/cinema.dart';
import 'package:flutter/services.dart';

class ReadData {
  Future<List<Cinema>> loadCinema() async {
    var data = await rootBundle.loadString("assets/data/cinema.json");
    var json = jsonDecode(data);
    return (json["data"] as List).map((d) => Cinema.fromJson(d)).toList();
  }
}
