import 'package:ceni_fruit/service/catch_dio_exception.dart';
import 'package:dio/dio.dart';

class MovieService {
  final Dio dio;

  MovieService(this.dio);

  Future<Map<String, dynamic>> getMovieHot() async {
    try {
      final response = await dio.get("/movie/get/hot");

      return {
        "statusCode": response.statusCode,
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "movie": response.statusCode == 200 ? response.data["movie"] : [],
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {
        "statusCode": error.response?.statusCode,
        "success": false,
        "message": errorMessage,
        "movie": [],
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "success": false,
        "message": "Lỗi không xác định: ${e.toString()}",
        "movie": [],
      };
    }
  }

  Future<Map<String, dynamic>> getMovies() async {
    try {
      final response = await dio.get("/movie/get/all");
      return {
        "statusCode": response.statusCode,
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "movie": response.statusCode == 200 ? response.data["movie"] : [],
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {
        "statusCode": error.response?.statusCode,
        "success": false,
        "message": errorMessage,
        "movie": [],
      };
    } catch (error) {
      return {
        "statusCode": 500,
        "success": false,
        "message": "Lỗi không xác định: ${error.toString()}",
        "movie": [],
      };
    }
  }

  Future<Map<String, dynamic>> ratingMovie(String idMovie, double score) async {
    try {
      final response = await dio.post(
        "/rate_movie/update/rate",
        data: {"idMovie": idMovie, "score": score},
      );
      return {
        "success": response.statusCode == 200,
        "message": response.data["message"],
        "movie": response.statusCode == 200 ? response.data["movie"] : [],
      };
    } on DioException catch (error) {
      String errorMessage = getDioErrorMessage(error);

      return {
        "success": false,
        "message": errorMessage,
        "movie": [],
        "typeError": error.response?.data["typeError"] ?? error.error,
      };
    } catch (error) {
      return {
        "success": false,
        "message": "Lỗi không xác định: ${error.toString()}",
        "movie": [],
      };
    }
  }
}
