import 'package:ceni_fruit/service/catch_dio_exception.dart';
import 'package:dio/dio.dart';

class FoodDrinkService {
  final Dio dio;

  FoodDrinkService(this.dio);

  Future<Map<String, dynamic>> getAllFoodDrink() async {
    try {
      final response = await dio.get("/food_drink/get/all");
      return {
        "statusCode": response.statusCode,
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "food_drink": response.statusCode == 200
            ? response.data["food_drink"]
            : [],
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {
        "statusCode": error.response?.statusCode,
        "success": false,
        "message": errorMessage,
        "food_drink": [],
      };
    } catch (error) {
      return {
        "statusCode": 500,
        "success": false,
        "message": "Lỗi không xác định: ${error.toString()}",
        "food_drink": [],
      };
    }
  }
}
