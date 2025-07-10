import 'package:ceni_fruit/service/user_service.dart';
import 'package:dio/dio.dart';

class AuthInerceptor extends Interceptor {
  final Dio dio;
  final UserService userService;
  final List<String> excludedPaths;

  AuthInerceptor(
    this.dio, {
    this.excludedPaths = const [],
    required this.userService,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    bool needsToken = true;
    for (var path in excludedPaths) {
      if (options.path.contains(path)) {
        needsToken = false;
        break;
      }
    }

    if (needsToken) {
      final token = await userService.getToken();
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      } else {
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: "Chưa được xác minh",
          message:
              "Bạn cần đăng nhập để thực hiện chức năng này. Bấm vào đây để đăng nhập.",
        );

        return handler.reject(error);
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await userService.logout();
    }

    handler.next(err);
  }
}
