import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routers.dart';
import '../model/user.dart';
import '../model/detail_movie.dart';
import '../model/cinema.dart';
import '../model/booking.dart';
import '../model/order_food_drink.dart';
import '../model/params_pay_page.dart';
import '../provider/cinema_provider.dart';

class NavigationHelper {
  // Home navigation
  static void goToHome({int index = 0}) {
    Get.toNamed(Routers.homePage, arguments: index);
  }

  static void goToHomeAndRemove({int index = 0}) {
    Get.offAllNamed(Routers.homePage, arguments: index);
  }

  // Pop về trang cụ thể

  static void goBackToSpecificPage(String routeName) {
    Get.back();
    Get.until((route) => route.settings.name == routeName);
  }

  // Auth navigation
  static void goToRegister({String? returnRoute}) {
    Get.toNamed(Routers.register, arguments: {'returnRoute': returnRoute});
  }

  static void goToLogin({String? returnRoute}) {
    Get.toNamed(Routers.login, arguments: {'returnRoute': returnRoute});
  }

  static void goToForgotPassword({String? email, String? returnRoute}) {
    Get.toNamed(
      Routers.forgotPassword,
      arguments: {"email": email, "returnRoute": returnRoute},
    );
  }

  static void goToVerifyEmail({required String email, String? returnRoute}) {
    Get.toNamed(
      Routers.verifyEmail,
      arguments: {"email": email, "returnRoute": returnRoute},
    );
  }

  // User navigation
  static void goToUserInfo({required User user}) {
    Get.toNamed(Routers.inforUser, arguments: user);
  }

  // Movie navigation
  static void goToDetailMovie({required DetailMovie detailMovie}) {
    Get.toNamed(Routers.detailMovie, arguments: detailMovie);
  }

  // Cinema navigation
  static void goToDetailCinema({
    required Cinema cinema,
    required List<DetailCinemaState> detailCinemaState,
  }) {
    Get.toNamed(
      Routers.detailCinema,
      arguments: {'cinema': cinema, 'detailCinemaState': detailCinemaState},
    );
  }

  // Booking navigation
  static void goToBooking({required Booking booking}) {
    Get.toNamed(Routers.booking, arguments: booking);
  }

  static void goToFoodDrinks({required ParamsOrderFoodDrink params}) {
    Get.toNamed(Routers.foodDrinks, arguments: params);
  }

  static void goToPay({required ParamsPayPage params}) {
    Get.toNamed(Routers.pay, arguments: params);
  }

  static Future<Map<String, dynamic>?> goToWebViewPaypal({
    required String approvalUrl,
  }) async {
    final result = await Get.toNamed(
      Routers.paypalWebview,
      arguments: approvalUrl,
    );
    return result as Map<String, dynamic>?;
  }

  static Future<Map<String, dynamic>?> goToWebViewMoMo({
    required String approvalUrl,
  }) async {
    final result = await Get.toNamed(
      Routers.momoWebview,
      arguments: approvalUrl,
    );
    return result as Map<String, dynamic>?;
  }

  // Back navigation
  static void goBack() {
    Get.back();
  }

  static void goBackWithResult(dynamic result) {
    Get.back(result: result);
  }

  static void goBackToHome() {
    Get.until((route) => route.settings.name == Routers.initial);
  }
}
