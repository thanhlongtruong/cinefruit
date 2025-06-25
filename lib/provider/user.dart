import 'dart:convert';
import 'package:ceni_fruit/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User>>((
  ref,
) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AsyncValue<User>> {
  UserNotifier() : super(const AsyncValue.loading()) {
    loadUser();
  }

  Future<User> loadUser() async {
    try {
      state = const AsyncValue.loading();

      var data = await rootBundle.loadString("assets/data/user.json");
      var json = jsonDecode(data);

      User user = User.fromJson(json["data"]);

      state = AsyncValue.data(user);
      return user;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
