import 'package:ceni_fruit/service/catch_dio_exception.dart';
import 'package:dio/dio.dart';

class OrderService {
  final Dio dio;

  OrderService(this.dio);

  Future<Map<String, dynamic>> getOrderWithTicket() async {
    try {
      final response = await dio.get("/order/get");

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

  Future<Map<String, dynamic>> delOrderWithTicket(String idOrder) async {
    try {
      final response = await dio.post("/order/del", data: {"idOrder": idOrder});

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

  Future<Map<String, dynamic>> getBooked(String idRoom, String idMovie) async {
    try {
      final response = await dio.get(
        "/order/get/room?idRoom=$idRoom&idMovie=$idMovie",
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

  Future<Map<String, dynamic>> createOrder(Object data) async {
    try {
      final response = await dio.post("/order/add", data: data);

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

  Future<Map<String, dynamic>> updateTransaction(Object data) async {
    try {
      final response = await dio.post("/order/update/transaction", data: data);

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

  Future<Map<String, dynamic>> updatePayUrl(Object data) async {
    try {
      final response = await dio.post("/order/update/payUrl", data: data);

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
