import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/model/user.dart';
import 'package:ceni_fruit/service/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final dio = ref.read(dioProvider);
  return UserService(dio);
});

final userProfile =
    StateNotifierProvider<UserProfileProvider, AsyncValue<User?>>(
      (ref) => UserProfileProvider(ref.read(userServiceProvider)),
    );

class UserProfileProvider extends StateNotifier<AsyncValue<User?>> {
  final UserService service;

  UserProfileProvider(this.service) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await service.getSavedUser();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshProfile() async {
    loadProfile();
  }

  void clearProfile() async {
    try {
      await service.logout();
      state = AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
