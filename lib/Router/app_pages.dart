import 'package:ceni_fruit/Router/routers.dart';
import 'package:ceni_fruit/home_creen.dart';
import 'package:ceni_fruit/model/booking.dart';
import 'package:ceni_fruit/model/cinema.dart';
import 'package:ceni_fruit/model/detail_movie.dart';
import 'package:ceni_fruit/model/order_food_drink.dart';
import 'package:ceni_fruit/model/params_pay_page.dart';
import 'package:ceni_fruit/model/user.dart';
import 'package:ceni_fruit/pages/Payment/paypal_webview.dart';
import 'package:ceni_fruit/pages/Payment/momo_webview.dart';
import 'package:ceni_fruit/pages/booking_page.dart';
import 'package:ceni_fruit/pages/detail_cinema_page.dart';
import 'package:ceni_fruit/pages/detail_movie_page.dart';
import 'package:ceni_fruit/pages/forgot_password.dart';
import 'package:ceni_fruit/pages/info_account_page.dart';
import 'package:ceni_fruit/pages/login_page.dart';
import 'package:ceni_fruit/pages/order_food_drink.dart';
import 'package:ceni_fruit/pages/pay_page.dart';
import 'package:ceni_fruit/pages/sign_up_page.dart';
import 'package:ceni_fruit/pages/verify_email_page.dart';
import 'package:ceni_fruit/provider/cinema_provider.dart';
import 'package:ceni_fruit/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static const String initial = Routers.initial;

  static final pageRouters = [
    GetPage(
      name: Routers.initial,
      page: () => SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routers.homePage,
      page: () {
        final args = Get.arguments as int?;
        return HomeCreen(index: args ?? 0);
      },
      transition: Transition.fade,
    ),

    GetPage(
      name: Routers.register,
      page: () => const SignUpCreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.login,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.forgotPassword,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return ForgotPassword(
          email: args["email"],
          returnRoute: args["returnRoute"],
        );
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.verifyEmail,
      page: () {
        return VerifyEmailPage();
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.inforUser,
      page: () {
        final args = Get.arguments as User;
        return InfoAccountPage(user: args);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.detailMovie,
      page: () {
        final args = Get.arguments as DetailMovie;
        return DetailMovieScreen(detailMovie: args);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.detailCinema,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final Cinema cinema = args['cinema'] as Cinema;
        final List<DetailCinemaState> detailCinemaState =
            args['detailCinemaState'] as List<DetailCinemaState>;
        return DetailCinemaPage(
          cinema: cinema,
          detailCinemaState: detailCinemaState,
        );
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.booking,
      page: () {
        final args = Get.arguments as Booking;
        return BookingPage(booking: args);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.foodDrinks,
      page: () {
        final args = Get.arguments as ParamsOrderFoodDrink;
        return OrderFoodDrink(paramsOrderFoodDrink: args);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.pay,
      page: () {
        final args = Get.arguments as ParamsPayPage;
        return PayPage(paramsPayPage: args);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.paypalWebview,
      page: () {
        final args = Get.arguments as String;
        return PayPalWebView(approvalUrl: args);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routers.momoWebview,
      page: () {
        final args = Get.arguments as String;
        return MomoWebview(approvalUrl: args);
      },
      transition: Transition.rightToLeft,
    ),
  ];
}
