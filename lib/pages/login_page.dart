import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/Router/routers.dart';
import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/provider/movie_hot_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/path_images.dart';
import 'package:ceni_fruit/provider/user_handle_provider.dart';
import 'package:get/get.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? returnRoute;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    returnRoute = args?['returnRoute'];
  }

  Future<void> handleLogin() async {
    final email = emailController.text;
    final password = passwordController.text;

    final navigator = Navigator.of(context);
    try {
      Get.dialog(Center(child: circularProgress), barrierDismissible: false);
      final dataLogin = await ref
          .read(userHandleProvider.notifier)
          .login(email, password);

      if (navigator.canPop()) {
        navigator.pop();
      }

      if (dataLogin["statusCode"] != null && dataLogin["statusCode"] == 200) {
        if (dataLogin["data"]["user"]["verification"] == false) {
          await ref.read(userHandleProvider.notifier).logout();

          NavigationHelper.goToVerifyEmail(
            email: dataLogin["data"]["user"]["email"],
            returnRoute: returnRoute,
          );
        } else {
          showSnackbar(
            message: dataLogin["message"],
            title: "Đăng nhập",
            type: "success",
          );

          await Future.delayed(const Duration(milliseconds: 500));

          switch (returnRoute) {
            case Routers.detailMovie:
              {
                NavigationHelper.goBackToSpecificPage(Routers.detailMovie);

                break;
              }
            case Routers.detailCinema:
              {
                NavigationHelper.goBackToSpecificPage(Routers.detailCinema);
                break;
              }
            default:
              NavigationHelper.goToHomeAndRemove();
          }
        }
      } else {
        showSnackbar(
          message: dataLogin["message"],
          title: "Đăng nhập",
          type: "error",
        );
      }
    } catch (e) {
      if (navigator.canPop()) {
        navigator.pop();
      }
      showSnackbar(
        title: "Lỗi hệ thống",
        message: "Có lỗi xảy ra khi đăng nhập: $e",
        type: "error",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final background = ref.read(backgroundMovieHot.notifier).state;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (background.isNotEmpty) ...backgroundApp(background),

          Padding(
            padding: const EdgeInsets.only(
              top: 230,
              right: spacingMedium,
              left: spacingMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: spacingMedium,
                  children: [
                    GestureDetector(
                      onTap: () {
                        switch (returnRoute) {
                          case Routers.detailMovie:
                            {
                              NavigationHelper.goBackToSpecificPage(
                                Routers.detailMovie,
                              );

                              break;
                            }
                          case Routers.detailCinema:
                            {
                              NavigationHelper.goBackToSpecificPage(
                                Routers.detailCinema,
                              );
                              break;
                            }
                          case Routers.userPage:
                            {
                              NavigationHelper.goToHome(index: 3);
                              break;
                            }
                          case Routers.bookedPage:
                            {
                              NavigationHelper.goToHome(index: 2);
                              break;
                            }
                          default:
                            NavigationHelper.goToHomeAndRemove();
                        }
                      },
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: colorTextApp,
                        size: iconfontSizeNormal,
                      ),
                    ),
                    Text("ĐĂNG NHẬP", style: styleTopic),
                  ],
                ),
                const SizedBox(height: spacingLarge),
                buildFeld(
                  "",
                  "Nhập email",
                  emailController,
                  Icon(Icons.email_outlined),
                  null,
                  "",
                ),
                const SizedBox(height: spacingBig),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: spacingMedium,
                  children: [
                    buildFeld(
                      "",
                      "Nhập mật khẩu",
                      passwordController,
                      Icon(Icons.lock_outline_rounded),
                      null,
                      "",
                      isPassword: true,
                    ),
                    GestureDetector(
                      onTap: () {
                        final String email = emailController.text;
                        if (email.isEmpty) {
                          showSnackbar(
                            message: "Phải nhập email",
                            title: "Email",
                            type: "error",
                          );
                        } else if (!email.contains("@gmail.com") ||
                            email.split("@").length != 2 ||
                            email.split("@")[0].length < 3) {
                          showSnackbar(
                            message: "Email không hợp lệ",
                            title: "Email",
                            type: "error",
                          );
                        } else {
                          NavigationHelper.goToForgotPassword(
                            email: email,
                            returnRoute: returnRoute,
                          );
                        }
                      },
                      child: Text(
                        "Quên mật khẩu",
                        style: TextStyle(
                          letterSpacing: letterSpacingSmall,
                          fontWeight: fontWeightMedium,
                          color: hexColorLogout,
                          fontSize: textfontSizeApp,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacingLarge),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: handleLogin,
                    style: buttonStyle,

                    child: Text("Đăng nhập", style: textStyleElevatedButton),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: spacingBig,
            width: MediaQuery.of(context).size.width,
            child: Row(
              spacing: spacingMedium,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bạn chưa có tài khoản? ",
                  style: textNoteBottomStyle(colorTextApp),
                ),
                InkWell(
                  onTap: () {
                    NavigationHelper.goToRegister(returnRoute: returnRoute);
                  },
                  child: Text(
                    "Đăng kí",
                    style: textNoteBottomStyle(colorButton),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
