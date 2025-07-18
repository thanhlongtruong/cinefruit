import 'package:ceni_fruit/service/catch_dio_exception.dart';
import 'package:dio/dio.dart';

class MomoService {
  final Dio dio;

  MomoService(this.dio);

  Future<Map<String, dynamic>> payMoMo(Object data) async {
    try {
      final response = await dio.post("/momo/pay", data: data);
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

  Future<Map<String, dynamic>> transactionMoMo(String orderId) async {
    try {
      final response = await dio.get(
        "/momo/transaction-status?orderId=$orderId",
      );
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
