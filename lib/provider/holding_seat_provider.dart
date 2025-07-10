import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/model/holding_seat.dart';
import 'package:ceni_fruit/service/holding_seat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final holdingSeatServiceProvider = Provider<HoldingSeatService>((ref) {
  final dio = ref.read(dioProvider);
  return HoldingSeatService(dio);
});

final holdingSeatNofierProvider =
    StateNotifierProvider<
      HoldingSeatProvider,
      AsyncValue<HoldingSeatUserAndDiff>
    >((ref) {
      return HoldingSeatProvider(ref);
    });

class HoldingSeatUserAndDiff {
  HoldingSeat? holdingSeat;
  List<String> seatsDiff;

  HoldingSeatUserAndDiff(this.holdingSeat, this.seatsDiff);
}

class HoldingSeatProvider
    extends StateNotifier<AsyncValue<HoldingSeatUserAndDiff>> {
  final Ref ref;

  HoldingSeatProvider(this.ref) : super(const AsyncValue.loading()) {
    getHoldingSeatUser();
  }

  Future<void> getHoldingSeatUser() async {
    try {
      state = const AsyncValue.loading();

      final data = await ref
          .read(holdingSeatServiceProvider)
          .getSelectedSeatUser();

      if (!data["success"]) {
        throw Exception(data["message"]);
      }

      final seatUser = data["data"]["seatUser"] != null
          ? HoldingSeat.fromJson(data["data"]["seatUser"])
          : null;

      final seatsDiff = (data["data"]["seatsDiff"] as List)
          .map((s) => s.toString())
          .toList();

      state = AsyncValue.data(HoldingSeatUserAndDiff(seatUser, seatsDiff));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
