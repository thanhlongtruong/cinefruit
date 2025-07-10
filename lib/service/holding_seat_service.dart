import 'package:ceni_fruit/service/catch_dio_exception.dart';
import 'package:dio/dio.dart';

class HoldingSeatService {
  final Dio dio;

  HoldingSeatService(this.dio);

  Future<Map<String, dynamic>> getSelectedSeatUser() async {
    try {
      final response = await dio.get("/holding_seat/get/user");

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

  Future<Map<String, dynamic>> getSelectedSeat(String idMovieRoom) async {
    try {
      final response = await dio.get(
        "/holding_seat/get?idMovieRoom=$idMovieRoom",
      );

      return {
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "data": response.statusCode == 200 ? response.data : null,
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {
        "success": false,
        "message": errorMessage,
        "data": null,
        "typeError": error.response?.data["typeError"] ?? error.error,
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi không xác định: ${e.toString()}",
        "data": null,
      };
    }
  }

  Future<Map<String, dynamic>> getAllSelectedSeat() async {
    try {
      final response = await dio.get("/holding_seat/get/all");

      return {
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "holding_seats": response.statusCode == 200
            ? response.data["holding_seats"]
            : [],
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {"success": false, "message": errorMessage, "holding_seats": []};
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi không xác định: ${e.toString()}",
        "holding_seats": [],
      };
    }
  }

  Future<Map<String, dynamic>> chooseSeat({
    required String idMovieRoom,
    required String seat,
  }) async {
    try {
      final response = await dio.post(
        "/holding_seat/add",
        data: {"seat": seat, "idMovieRoom": idMovieRoom},
      );

      return {
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "data": response.statusCode == 200 ? response.data : [],
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {"success": false, "message": errorMessage, "holding_seats": []};
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi không xác định: ${e.toString()}",
        "holding_seats": [],
      };
    }
  }

  Future<Map<String, dynamic>> undoSeat(String idHoldingSeat) async {
    try {
      final response = await dio.post(
        "/holding_seat/del",
        data: {"idHoldingSeat": idHoldingSeat},
      );

      return {
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "data": response.statusCode == 200 ? response.data : [],
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {"success": false, "message": errorMessage, "holding_seats": []};
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi không xác định: ${e.toString()}",
        "holding_seats": [],
      };
    }
  }
}
