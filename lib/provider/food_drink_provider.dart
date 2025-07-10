import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/model/food_drink.dart';
import 'package:ceni_fruit/service/food_drink_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foodDrinkServiceProvider = Provider<FoodDrinkService>((ref) {
  final dio = ref.read(dioProvider);
  return FoodDrinkService(dio);
});

final foodDrinkProvider =
    StateNotifierProvider<FoodDrinkNotifier, AsyncValue<List<FoodDrink>>>((
      ref,
    ) {
      return FoodDrinkNotifier(ref.read(foodDrinkServiceProvider));
    });

class FoodDrinkNotifier extends StateNotifier<AsyncValue<List<FoodDrink>>> {
  final FoodDrinkService foodDrinkService;

  FoodDrinkNotifier(this.foodDrinkService) : super(const AsyncValue.loading()) {
    loadFoodDrink();
  }

  Future<void> loadFoodDrink() async {
    try {
      state = const AsyncValue.loading();

      final data = await foodDrinkService.getAllFoodDrink();

      if (!data["success"]) {
        throw Exception(data["message"]);
      }

      List<FoodDrink> foodDrink = (data["food_drink"] as List)
          .map((fd) => FoodDrink.fromJson(fd))
          .toList();

      state = AsyncValue.data(foodDrink);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refreshFoodDrink() async {
    loadFoodDrink();
  }
}
