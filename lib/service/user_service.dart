import 'dart:convert';

import 'package:ceni_fruit/model/user.dart';
import 'package:ceni_fruit/service/catch_dio_exception.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio dio;

  UserService(this.dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return {"message": "Vui lòng nhập email và mật khẩu."};
      }

      final response = await dio.post(
        "/user/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        if (response.data.containsKey("accessToken") &&
            response.data.containsKey("user")) {
          final token = response.data["accessToken"];
          final user = jsonEncode(response.data["user"]);
          await saveToken(token);
          await saveUser(user);
          return {
            "statusCode": response.statusCode,
            "message": response.data['message'],
            "data": response.data,
          };
        } else {
          return {
            "statusCode": response.statusCode,
            "message": response.data['message'],
          };
        }
      }

      return {
        "statusCode": response.statusCode,
        "message": response.data['message'],
      };
    } on DioException catch (e) {
      var data = e.response?.data;
      String? message;
      if (data is List && data.isNotEmpty) {
        message = data.first['msg'];
      } else if (data is Map && data.isNotEmpty) {
        message = data['message'];
      } else {
        message = "Lỗi không xác định";
      }
      return {"statusCode": e.response?.statusCode, "message": message};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      if (data['password'].isEmpty ||
          data['passwordConfirm'].isEmpty ||
          data['email'].isEmpty ||
          data['name'].isEmpty ||
          data['birthday'].isEmpty) {
        return {"message": "Vui lòng điền đầy đủ thông tin."};
      }
      if (data["name"].length < 2) {
        return {"message": "Tên phải có ít nhất 2 ký tự."};
      }
      if (data["password"].length < 8) {
        return {"message": "Mật khẩu phải có ít nhất 8 ký tự."};
      }
      if (!data["email"].contains("@gmail.com")) {
        return {"message": "Email phải có đuôi @gmail.com."};
      }
      if (data["email"].contains("@gmail.com")) {
        var splitEmail = data["email"].split("@");
        if (splitEmail.length != 2) {
          return {"message": "Email không hợp lệ."};
        }
        if (splitEmail[0].length < 3) {
          return {"message": "Email không hợp lệ."};
        }
      }
      if (data['password'] != data['passwordConfirm']) {
        return {"message": "Mật khẩu và xác nhận mật khẩu không khớp."};
      }
      final res = await dio.post("/user/register", data: data);
      return {
        "statusCode": res.statusCode,
        "message": res.data['message'],
        "data": res.data['data'],
      };
    } on DioException catch (e) {
      var data = e.response?.data;
      String? message;
      if (data is List && data.isNotEmpty) {
        message = data.first['msg'];
      } else if (data is Map && data.isNotEmpty) {
        message = data['message'];
      } else {
        message = "Lỗi không xác định";
      }
      return {"statusCode": e.response?.statusCode, "message": message};
    }
  }

  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> data) async {
    try {
      if (data["name"].length < 2) {
        return {"message": "Tên phải có ít nhất 2 ký tự."};
      }
      if (data["updatePassword"] &&
          (data["password"].length < 8 ||
              data["newPassword"].length < 8 ||
              data['confirmNewPassword'].length < 8)) {
        return {"message": "Mật khẩu phải có ít nhất 8 ký tự."};
      }

      if (data["updatePassword"] && data["newPassword"] == data["password"]) {
        return {
          "message": "Mật khẩu mới không được trùng với mật khẩu hiện tại.",
        };
      }

      if (data["updatePassword"] &&
          data['newPassword'] != data['confirmNewPassword']) {
        return {"message": "Mật khẩu và xác nhận mật khẩu không khớp."};
      }

      final response = await dio.post(
        "/user/update",
        data: {
          "name": data["name"],
          "password": data["password"],
          "newPassword": data["newPassword"],
          "updatePassword": data["updatePassword"],
        },
      );

      if (response.statusCode == 200) {
        if (response.data["user"] != null) {
          final user = jsonEncode(response.data["user"]);
          await saveUser(user);
        }
      }

      return {
        "statusCode": response.statusCode,
        "message": response.data['message'],
        "data": response.data,
      };
    } on DioException catch (e) {
      var data = e.response?.data;
      String? message;
      if (data is List && data.isNotEmpty) {
        message = data.first['msg'];
      } else if (data is Map && data.isNotEmpty) {
        message = data['message'];
      } else {
        message = "Lỗi không xác định";
      }
      return {"statusCode": e.response?.statusCode, "message": message};
    }
  }

  Future<void> saveToken(String token) async {
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.setString("accessToken", token);
  }

  Future<void> saveUser(String user) async {
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.setString("user", user);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  Future<User?> getSavedUser() async {
    final pref = await SharedPreferences.getInstance();
    final user = pref.getString("user");

    if (user != null) {
      final userDecode = jsonDecode(user);
      return User.fromJson(userDecode);
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    await prefs.remove("user");
  }

  Future<Map<String, dynamic>> sendVerificationEmail(String email) async {
    try {
      final response = await dio.post(
        "/user/verificarion-email",
        data: {"email": email},
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
  Future<Map<String, dynamic>> updateVerificationEmail(String email) async {
    try {
      final response = await dio.post(
        "/user/update/verification",
        data: {"email": email},
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
