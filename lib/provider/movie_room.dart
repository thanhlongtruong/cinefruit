import 'dart:convert';

import 'package:ceni_fruit/model/movie_room.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRoomProvider =
    StateNotifierProvider<MovieRoomNotifer, AsyncValue<List<MovieRoom>>>((ref) {
      return MovieRoomNotifer();
    });

class MovieRoomNotifer extends StateNotifier<AsyncValue<List<MovieRoom>>> {
  MovieRoomNotifer() : super(const AsyncValue.loading()) {
    loadMovieRoom();
  }

  Future<List<MovieRoom>> loadMovieRoom() async {
    try {
      state = AsyncValue.loading();

      var data = await rootBundle.loadString("assets/data/movie_room.json");
      var json = jsonDecode(data);

      List<MovieRoom> movieRooms = (json["data"] as List)
          .map((mr) => MovieRoom.fromJson(mr))
          .toList();
      state = AsyncValue.data(movieRooms);
      return movieRooms;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> refresh() async {
    await loadMovieRoom();
  }
}
