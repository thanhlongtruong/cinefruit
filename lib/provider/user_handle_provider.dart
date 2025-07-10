import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/service/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ceni_fruit/provider/user_profile_provider.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final dio = ref.read(dioProvider);
  return UserService(dio);
});

final userHandleProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<Map<String, dynamic>?>>((
      ref,
    ) {
      final service = ref.read(userServiceProvider);
      return UserNotifier(service, ref);
    });

class UserNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final UserService userService;
  final Ref ref;

  UserNotifier(this.userService, this.ref) : super(const AsyncValue.data(null));

  Future<Map<String, dynamic>> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await userService.login(email, password);

      state = AsyncValue.data(result);
      await ref.read(userProfile.notifier).refreshProfile();
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return {"statusCode": 500, "message": "Lỗi không xác định"};
    }
  }

  Future<Map<String, dynamic>> update(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final result = await userService.updateUser(data);
      
      state = AsyncValue.data(result);
      await ref.read(userProfile.notifier).refreshProfile();
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return {"statusCode": 500, "message": "Lỗi không xác định"};
    }
  }

  Future<void> logout() async {
    try {
      await userService.logout();
      state = const AsyncValue.data(null);
      ref.read(userProfile.notifier).clearProfile();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
