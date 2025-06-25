import 'dart:convert';

import 'package:ceni_fruit/model/movie_room.dart';
import 'package:ceni_fruit/model/order.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderParams {
  final MovieRoom movieRoom;

  OrderParams({required this.movieRoom});
}

final orderProvider =
    StateNotifierProviderFamily<
      OrderNotifier,
      AsyncValue<List<Order>>,
      MovieRoom
    >((ref, movieRoom) => OrderNotifier(movieRoom: movieRoom));

class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  late MovieRoom _movieRoom;

  OrderNotifier({required MovieRoom movieRoom})
    : super(const AsyncValue.loading()) {
    _movieRoom = movieRoom;
    loadOrder();
  }

  Future<List<Order>> loadOrder() async {
    try {
      state = const AsyncValue.loading();

      var data = await rootBundle.loadString("assets/data/order.json");
      var json = jsonDecode(data);

      List<Order> orders = (json["data"] as List)
          .map((t) => Order.fromJson(t))
          .toList();

      if (_movieRoom.id != null) {
        orders = orders
            .where((order) => order.idMovieRoom == _movieRoom.id)
            .toList();
      }

      state = AsyncValue.data(orders);
      return orders;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> refreshOrder() async {
    loadOrder();
  }
}
