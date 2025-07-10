import 'package:dio/dio.dart';

String getDioErrorMessage(DioException error) {
  String errorMessage;

  if (error.response != null && error.response!.data is Map) {
    errorMessage =
        error.response!.data["message"] ??
        error.message ??
        "Lỗi không xác định";
  } else if (error.type == DioExceptionType.connectionTimeout) {
    errorMessage = "Kết nối đến máy chủ quá thời gian";
  } else if (error.type == DioExceptionType.connectionError) {
    errorMessage = "Không thể kết nối đến máy chủ";
  } else {
    errorMessage = error.message ?? "Lỗi không xác định";
  }

  return errorMessage;
}
