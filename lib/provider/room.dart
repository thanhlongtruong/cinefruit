import 'dart:convert';

import 'package:ceni_fruit/model/room.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomProvider =
    StateNotifierProvider.autoDispose<RoomNotifier, AsyncValue<List<Room>>>(
      (ref) => RoomNotifier(),
    );

class RoomNotifier extends StateNotifier<AsyncValue<List<Room>>> {
  RoomNotifier() : super(const AsyncValue.loading()) {
    loadRooms();
  }

  Future<List<Room>> loadRooms() async {
    try {
      state = const AsyncValue.loading();

      var data = await rootBundle.loadString("assets/data/room.json");
      var json = jsonDecode(data);

      List<Room> rooms = (json["data"] as List)
          .map((r) => Room.fromJson(r))
          .toList();
      state = AsyncValue.data(rooms);
      return rooms;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> refreshRoom() async {
    loadRooms();
  }
}
