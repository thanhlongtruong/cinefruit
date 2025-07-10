import 'package:ceni_fruit/service/catch_dio_exception.dart';
import 'package:dio/dio.dart';

class PaymentMethodService {
  final Dio dio;

  PaymentMethodService(this.dio);

  Future<Map<String, dynamic>> getPaymentMethod() async {
    try {
      final response = await dio.get("/payment_method/get/all");

      return {
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "payment_methods": response.statusCode == 200
            ? response.data["payment_methods"]
            : [],
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {"success": false, "message": errorMessage, "payment_method": []};
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi không xác định: ${e.toString()}",
        "payment_method": [],
      };
    }
  }
}
