import 'package:ceni_fruit/service/catch_dio_exception.dart';
import 'package:dio/dio.dart';

class PaypalService {
  final Dio dio;

  PaypalService(this.dio);

  Future<Map<String, dynamic>> createOrder(Object data) async {
    try {
      final response = await dio.post("/paypal/pay", data: data);
      return {
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "data": response.statusCode == 200 ? response.data : null,
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {"success": false, "message": errorMessage, "data": null};
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi không xác định: ${e.toString()}",
        "data": null,
      };
    }
  }
}
