import 'package:ceni_fruit/service/catch_dio_exception.dart';
import 'package:dio/dio.dart';

class MovieRoomService {
  final Dio dio;

  MovieRoomService(this.dio);

  Future<Map<String, dynamic>> getMovieRoom(String idMovie, String date) async {
    try {
      final response = await dio.get(
        "/movie_room/get/movie?idMovie=$idMovie&date=$date",
      );
      return {
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "data": response.statusCode == 200 ? response.data : [],
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {"success": false, "message": errorMessage, "data": []};
    } catch (error) {
      return {
        "success": false,
        "message": "Lỗi không xác định: ${error.toString()}",
        "data": [],
      };
    }
  }
}
