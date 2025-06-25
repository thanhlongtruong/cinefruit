import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:ceni_fruit/model/cinema.dart';
import 'package:flutter/services.dart';

final cinemaProvider =
    StateNotifierProvider<CinemaNotifier, AsyncValue<List<Cinema>>>((ref) {
      return CinemaNotifier();
    });

class CinemaNotifier extends StateNotifier<AsyncValue<List<Cinema>>> {
  CinemaNotifier() : super(const AsyncValue.loading()) {
    loadCinemsFromJson();
  }

  Future<bool> isValidImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200 &&
          response.headers['content-type']?.startsWith('image/') == true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Cinema>> loadCinemsFromJson() async {
    try {
      state = const AsyncValue.loading();

      var data = await rootBundle.loadString("assets/data/cinema.json");
      var json = jsonDecode(data);

      List<Cinema> cinemas = (json["data"] as List)
          .map((c) => Cinema.fromJson(c))
          .toList();

      List<Cinema> setUrlImage = [];
      // for (var cinema in cinemas) {
      //   if (await isValidImageUrl(cinema.urlImage!)) {
      //     setUrlImage.add(cinema);
      //   }
      // }
      state = AsyncValue.data(cinemas);
      return cinemas;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> refreshCinema() async {
    loadCinemsFromJson();
  }
}
