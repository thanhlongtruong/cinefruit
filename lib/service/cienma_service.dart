import 'package:ceni_fruit/service/catch_dio_exception.dart';
import 'package:dio/dio.dart';

class CinemaService {
  final Dio dio;

  CinemaService(this.dio);

  Future<Map<String, dynamic>> getCinemas() async {
    try {
      final response = await dio.get("/cinema/get/all");
      return {
        "statusCode": response.statusCode,
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "cinema": response.statusCode == 200 ? response.data["cinema"] : [],
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {
        "statusCode": error.response?.statusCode,
        "success": false,
        "message": errorMessage,
        "cinema": [],
      };
    } catch (error) {
      return {
        "statusCode": 500,
        "success": false,
        "message": "Lỗi không xác định: ${error.toString()}",
        "cinema": [],
      };
    }
  }

  Future<Map<String, dynamic>> getCinema(String idCinema, String date) async {
    try {
      final response = await dio.get(
        "/cinema/get?idCinema=$idCinema&date=$date",
      );
      return {
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "data": response.statusCode == 200 ? response.data : null,
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {"success": false, "message": errorMessage, "data": null};
    } catch (error) {
      return {
        "success": false,
        "message": "Lỗi không xác định: ${error.toString()}",
        "data": null,
      };
    }
  }
}
